Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3BWFVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 00:21:39 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37604 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3BWFVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 00:21:38 -0500
Message-ID: <512851E0.7000808@wwwdotorg.org>
Date: Fri, 22 Feb 2013 22:21:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1361596520-19332-1-git-send-email-shc_work@mail.ru>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
> The driver can be used in various subsystems and therefore should not
> be unloaded when it is defined in the kernel configuration, so remove
> support for unloading it.

Why not fix the clients to module_get() at the appropriate times; then
you could still allow unloading, couldn't you?
