Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3BWWRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 17:17:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758512Ab3BWWRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 17:17:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
Date: Sat, 23 Feb 2013 22:17:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302232217.29290.arnd@arndb.de>
X-Provags-ID: V02:K0:n2pAr/6sSpiLfm1crsRex57JmLsU9axpg2GTsdJiubW
 eXnCWKMqWVmgiAWHVq6yW/L3020sTfbI54hcRsAW7tNw1iM8FR
 d99f0N1eJLP34bGx5t4qOxZnVyusdRqvMkQUis+BH//m3jMEEy
 vVq90RZGtxdFvfPlCNXH5ObIwsW4ezCZEKjNOZ+32GiRaGHnNe
 zluLEn+vjoqf1FpzmWs1T6O9JvoOb/grt+5m79KikQZ3M7WkMz
 H2fDS5omiRJn5Z8qC4g27fIWhZD+JsncUeErMscmevT9ZwbflR
 Eqioel9ZgDMVqFGnfK7wEZ8EONR47l688/OIG7E/XH6VccU3wf
 2oBx7cCH9geh9ZoIRwRU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2013, Alexander Shiyan wrote:
> The driver can be used in various subsystems and therefore should not
> be unloaded when it is defined in the kernel configuration, so remove
> support for unloading it.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>

I think the description is still wrong here, as mentioned before.

	Arnd
