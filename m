Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbaGJQn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:43:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:48558 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaGJQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:43:24 -0400
Date: Thu, 10 Jul 2014 09:38:29 -0700
From: Olof Johansson <olof@lixom.net>
To: Robin Schroer <sulamiification@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/platform/chrome: coding style fixes
Message-ID: <20140710163829.GA4378@quad.lixom.net>
References: <20140529184507.GA10635@shodan.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529184507.GA10635@shodan.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 08:45:07PM +0200, Robin Schroer wrote:
> added blank lines after declarations in some places
> 
> Signed-off-by: Robin Schroer <sulamiification@gmail.com>
> ---
>  drivers/platform/chrome/chromeos_laptop.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
> index 7f1a2e2..0e2785a 100644
> --- a/drivers/platform/chrome/chromeos_laptop.c
> +++ b/drivers/platform/chrome/chromeos_laptop.c
> @@ -177,6 +177,7 @@ static int __find_i2c_adap(struct device *dev, void *data)
>  	const char *name = data;
>  	static const char *prefix = "i2c-";
>  	struct i2c_adapter *adapter;
> +
>  	if (strncmp(dev_name(dev), prefix, strlen(prefix)) != 0)
>  		return 0;
>  	adapter = to_i2c_adapter(dev);
> @@ -231,6 +232,7 @@ static struct i2c_client *add_i2c_device(const char *name,
>  						struct i2c_board_info *info)
>  {
>  	const unsigned short addr_list[] = { info->addr, I2C_CLIENT_END };
> +
>  	return __add_probed_i2c_device(name,
>  				       find_i2c_adapter_num(type),
>  				       info,
> @@ -464,6 +466,7 @@ static struct platform_driver cros_platform_driver = {
>  static int __init chromeos_laptop_init(void)
>  {
>  	int ret;
> +
>  	if (!dmi_check_system(chromeos_laptop_dmi_table)) {
>  		pr_debug("%s unsupported system.\n", __func__);
>  		return -ENODEV;
> -- 
> 1.9.3
> 

Applied, thanks.


-Olof
