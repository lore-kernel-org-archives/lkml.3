Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3COKmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:42:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3COKmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:42:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[2]: [PATCH v7 2/2] mfd: syscon: Add non-DT support
Date: Fri, 15 Mar 2013 10:42:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>
References: <1363196060-1149-1-git-send-email-shc_work@mail.ru> <1363196060-1149-2-git-send-email-shc_work@mail.ru> <1363321590.65573886@f228.mail.ru>
In-Reply-To: <1363321590.65573886@f228.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151042.18867.arnd@arndb.de>
X-Provags-ID: V02:K0:VFzvFS93u7gzvM0M8KCKMO+f6Hob18dSd8uXZRFCwfy
 3WifGZIwr8kH5G0PrWhqQinKdVYz17MTn8HuglZSnhiPTnejzu
 19tbdA6cmDorNaNq1KAwUBD7+6Z5bDgYjzxxkUqUD+uFMZUz6l
 sxBRiUOilMyFdkxwXlgKAC5Q8kVQAyu9jS4dz/NJT6LcqOeXL9
 5eUoK2CD9jbnDR5kg/HEGKtHiBZyr9gCsMwLXvfUy43EB2O0Dm
 t0nrZjaJrEt/heY8nFI72gT2G0RPqzdK97/6zndXGnp8ePpkSc
 oESlvO6Ve2CUtVJP+FJ14gD74wOawcYOqdUis6Dz7NoYjDIJPB
 TzKHwSSC6YhTgCvsKkP0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Alexander Shiyan wrote:
> > On 14 March 2013 01:34, Alexander Shiyan <shc_work@mail.ru> wrote:
> > > This patch allow using syscon driver from the platform data, i.e.
> > > possibility using driver on systems without oftree support.
> > > For search syscon device from the client drivers,
> > > "syscon_regmap_lookup_by_pdevname" function was added.
> > >
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > 
> > Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

(both patches)

Acked-by: Arnd Bergmann <arnd@arndb.de>
 
> There remains only one question. Who can commit the patch to the kernel...

Samuel Ortiz handles MFD patches. Please send them again with him as the
recipient and the Acked-by tags added into the description.

	Arnd
