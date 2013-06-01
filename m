Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab3FALpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 07:45:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3FALpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 07:45:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Luebbe <jlu@pengutronix.de>
Subject: Re: [PATCH v2] pps-gpio: add device-tree binding and support
Date: Sat, 1 Jun 2013 13:44:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1588516.WvWWFWzAui@wuerfel> <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
In-Reply-To: <1370083449-11986-1-git-send-email-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306011344.36214.arnd@arndb.de>
X-Provags-ID: V02:K0:5jPsSWvouQxtJjJCUGin4D5yyPNahSTzTHbWsyQRwpt
 Nb7UZ8QSU6bqFpcfCDPw8zhFcWuC95uYXKH0DaQqTs6s/FrzS2
 L7U41eIsvaoPmjk6VEsVVed7Hee48V+PSD46JiZATMreoI3fMy
 4kwg/6IS6baA37eHVe2rNH+9NUcgjPrv/3CwssATuhYcnJxmq/
 UXghk5F6MoPr1u+sknk6ggYCEh6NMBmqRESI78El5g/CZfoR3e
 iMzb4h9hGYf1j6Y4FIdXLZr8g7okXDWXHFPSW80La6kfI0BEAb
 Fy0vILpXZ6QA8V1XxlpUFbqpfOf4CnrP5gGriyXrLvzyC4MhWM
 5iVdn68JsGCeSc+liSSU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 June 2013, Jan Luebbe wrote:
> Instead of allocating a struct pps_gpio_platform_data in the DT case, store
> the necessary information in struct pps_gpio_device_data itself. This avoids
> an additional allocation and the ifdef. It also gets rid of some indirection.
> 
> Also use dev_err instead of pr_err in the changed code.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
> 
Acked-by: Arnd Bergmann <arnd@arndb.de>
