Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3INLJY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:09:24 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40473 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab3INLJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:09:23 -0400
Message-ID: <52345201.6040501@kernel.org>
Date: Sat, 14 Sep 2013 13:09:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 13/38] Documentation: dt: iio: Add binding for LSM303DLH
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-14-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1378817379-8238-14-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree list cc.
On 09/10/13 13:49, Lee Jones wrote:
> LSM303DLH is a Magnetometer Sensor
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  .../bindings/iio/magnetometer/lsm303dlh.txt         | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/magnetometer/lsm303dlh.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/magnetometer/lsm303dlh.txt b/Documentation/devicetree/bindings/iio/magnetometer/lsm303dlh.txt
> new file mode 100644
> index 0000000..5938369
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/magnetometer/lsm303dlh.txt
> @@ -0,0 +1,21 @@
> +* STMicroelectronics Magnetometer Sensor
> +
> +Required properties:
> +  - compatible: Should be "st,lsm303dlh_magn"
> +  - reg: The I2C address of the sensor
> +
> +Optional properties:
> +  - vdd-supply: Phandle to the Vdd supply regulator
> +  - vddio-supply: Phandle to the Vdd-IO supply regulator
> +
> +Example:
> +
> +i2c@80128000 {
> +	lsm303dlh_magn@1e {
> +		compatible = "st,lsm303dlh_magn";
> +		reg = <0x1e>;
> +
> +		vdd-supply = <&ab8500_ldo_aux1_reg>;
> +		vddio-supply = <&db8500_vsmps2_reg>;
> +	};
> +};
> 
