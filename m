Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422785Ab3BGWis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:38:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422753Ab3BGWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:38:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 07/11] mei: bus: Implement bus driver data setter/getter
Date: Thu, 7 Feb 2013 22:38:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <1360270997-7639-8-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1360270997-7639-8-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072238.44578.arnd@arndb.de>
X-Provags-ID: V02:K0:0KpaTrOmpAD7p0s4O9lGDZcVjvNDZBAB0s1ic27NqSQ
 xQc0VNaEDjXfWw5RYrZa6XJEZbQIfWTEe6dLJExh8AzVd1KJGE
 qWOHo6tHybK7L0ugJ44qjMPexxR98GaXCyMp17uza6mggYdkP0
 cltsR6zMNRLQb0hNV5glMm0QeuwEGpvGxVYFGiF7G11ohi3KwR
 OmWWlXaLYbB3YNQuWqOZC++8RImP3RAhh/diCF7NrVNKDdiCNO
 CHEREoAEacHlbsXOUFjb/UbIBITDLW98zjfY8dJsBVTzZ6+T1a
 56vDFmmMXEnGyaUl1/U9EITxU50WuAxMSkjsaOimYMa/IbGh9Y
 1kkMYsQd0dr3t8cI2JEI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Tomas Winkler wrote:
> 
> +inline void *mei_bus_get_clientdata(const struct mei_bus_client *client)
> +{
> +       return dev_get_drvdata(&client->dev);
> +}
> +EXPORT_SYMBOL(mei_bus_get_clientdata);
> +

Did you really mean to export an inline function?

Can you make this a static inline function in a header file instead?

	Arnd
