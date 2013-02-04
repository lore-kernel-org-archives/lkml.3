Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3BDFp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 00:45:56 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51259 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3BDFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 00:45:53 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-41-510f4b1046f4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anatolij Gustschin'" <agust@denx.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        "'Stefano Babic'" <sbabic@denx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1359729703-24915-1-git-send-email-agust@denx.de>
In-reply-to: <1359729703-24915-1-git-send-email-agust@denx.de>
Subject: Re: [PATCH] video: add ili922x lcd driver
Date: Mon, 04 Feb 2013 14:45:51 +0900
Message-id: <00c701ce029a$e42d3470$ac879d50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4AikQy2/xWS7J5Rsu4bIgwlE+4ggB7l6CA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zfV0Bb/5AgwufeCxO9H1gtbi8aw6b
	A5PH501yAYxRXDYpqTmZZalF+nYJXBlrbzcwFzxZzlix9N8stgbGDW2MXYycHBICJhLrFt1h
	g7DFJC7cWw9kc3EICSxjlLj9fwYrTNHxN9NYIBKLGCU2zPjMDOH8YpRovjQfrIpNQE3iy5fD
	7CC2iICGRNvp42AdzALzmSQmLnwKlhASsJW49rmNGcTmFLCT2Hx3M9gdwgJGEgte7wOLswio
	SnzquA5WzwtUP/f4LUYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveAvVyAJ2qLvHory7EDUYS
	j3/cZoMoEZHY9+IdI8g9EgLr2CUevz7NCrFLQOLb5EMsEL2yEpsOMEN8LClxcMUNlgmMErOQ
	bJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZIrEntYFzZYHGIUYCD
	UYmHl+EXX6AQa2JZcWXuIUYJDmYlEd6rRkAh3pTEyqrUovz4otKc1OJDjMlAx05klhJNzgem
	gbySeENjYxMzE1MTc0tTc1PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwMjZk/Luuotd
	j8vywHdlDMeu8lVdOKN3b7LllbdHd3y/H+veX/3p4jvuZ1fP7bzDc2rzqdowvu/337JKL38+
	5c65zg1lJl39p7vNJ3YWzjs8W6+lpf32rooNX3YmcH+ZLJxdVSjAdSD4hfDDg/WMMyLq6veV
	zLYoUFpd3HRj45uTe+XFZzf4vJ6uxFKckWioxVxUnAgAcJNAivkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV0Bb/5Agx1dLBYn+j6wWlzeNYfN
	gcnj8ya5AMaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58A
	XbfMHKDRSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMtbcbmAueLGes
	WPpvFlsD44Y2xi5GTg4JAROJ42+msUDYYhIX7q1n62Lk4hASWMQosWHGZ2YI5xejRPOl+awg
	VWwCahJfvhxmB7FFBDQk2k4fZwEpYhaYzyQxceFTsISQgK3Etc9tzCA2p4CdxOa7m8HWCQsY
	SSx4vQ8sziKgKvGp4zpYPS9Q/dzjtxghbEGJH5PvgZ3ELKAlsX7ncSYIW15i85q3QL0cQKeq
	Szz6qwtxg5HE4x+32SBKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgRH8jOpHYwrGywOMQpwMCrx8DL84gsUYk0sK67MPcQowcGsJMJ71Qgo
	xJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAJJNXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScB
	QgLpiSWp2ampBalFMFuYODilGhh3Guovbnptvyg8fuv0HGNnVb27u2ce6rl7O6tWs11HcL3J
	zP/Sm9y6tRLW3f9ywWzftG2bEqvnFXV+3Hjs/5GyG4uUD34McN1nljJDbMaEHzvTtLcUH7py
	9tOkhFuyMr8m2pd07DGtYraTM7snqtwlJrFIbdnjYzM/cgfb3GAtP7DhFnPsMutXSizFGYmG
	WsxFxYkA58nmsygDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 01, 2013 11:42 PM, Anatolij Gustschin wrote

CC'ed Andrew Morton
> 
> From: Stefano Babic <sbabic@denx.de>
> 
> Add LCD driver for Ilitek ILI9221/ILI9222 controller.
> 
> Signed-off-by: Stefano Babic <sbabic@denx.de>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> ---
>  drivers/video/backlight/Kconfig   |    7 +
>  drivers/video/backlight/Makefile  |    1 +
>  drivers/video/backlight/ili922x.c |  586 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 594 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/video/backlight/ili922x.c
> 
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index 765a945..97b4672 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -59,6 +59,13 @@ config LCD_LTV350QV
> 
>  	  The LTV350QV panel is present on all ATSTK1000 boards.
> 
> +config LCD_ILI922X
> +	tristate "ILI Technology ILI9221/ILI9222 support"
> +	depends on SPI
> +	help
> +	  If you have a panel based on the ILI9221/9222 controller
> +	  chip then say y to include a driver for it.
> +
>  config LCD_ILI9320
>  	tristate "ILI Technology ILI9320 controller support"
>  	depends on SPI
> diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
> index e7ce729..3cfd901 100644
> --- a/drivers/video/backlight/Makefile
> +++ b/drivers/video/backlight/Makefile
> @@ -6,6 +6,7 @@ obj-$(CONFIG_LCD_HP700)		   += jornada720_lcd.o
>  obj-$(CONFIG_LCD_L4F00242T03)	   += l4f00242t03.o
>  obj-$(CONFIG_LCD_LMS283GF05)	   += lms283gf05.o
>  obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
> +obj-$(CONFIG_LCD_ILI922X)	   += ili922x.o
>  obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
>  obj-$(CONFIG_LCD_PLATFORM)	   += platform_lcd.o
>  obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
> diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> new file mode 100644
> index 0000000..18c33df
> --- /dev/null
> +++ b/drivers/video/backlight/ili922x.c
> @@ -0,0 +1,586 @@
> +/*
> + * (C) Copyright 2008
> + * Stefano Babic, DENX Software Engineering, sbabic@denx.de.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA

Please remove this comment. It is hard to keep track of the address of
Free Software Foundation.
Also, above mentioned address is not the same with the current address.

> + *
> + * This driver implements a lcd device for the ILITEK 922x display
> + * controller. The interface to the display is SPI and the display's
> + * memory is cyclically updated
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/fb.h>
> +#include <linux/init.h>
> +#include <linux/lcd.h>
> +#include <linux/of.h>
> +#include <linux/spi/spi.h>

Would you order inclusions of <linux/xxx.h> according to alphabetical
ordering, for readability?

> +
> +/* Register offset, see manual section 8.2 */
> +#define REG_START_OSCILLATION			0x00
> +#define REG_DRIVER_CODE_READ			0x00
> +#define REG_DRIVER_OUTPUT_CONTROL		0x01
> +#define REG_LCD_AC_DRIVEING_CONTROL		0x02
> +#define REG_ENTRY_MODE				0x03
> +#define REG_COMPARE_1				0x04
> +#define REG_COMPARE_2				0x05
> +#define REG_DISPLAY_CONTROL_1			0x07
> +#define REG_DISPLAY_CONTROL_2			0x08
> +#define REG_DISPLAY_CONTROL_3			0x09
> +#define REG_FRAME_CYCLE_CONTROL			0x0B
> +#define REG_EXT_INTF_CONTROL			0x0C
> +#define REG_POWER_CONTROL_1			0x10
> +#define REG_POWER_CONTROL_2			0x11
> +#define REG_POWER_CONTROL_3			0x12
> +#define REG_POWER_CONTROL_4			0x13
> +#define REG_RAM_ADDRESS_SET			0x21
> +#define REG_WRITE_DATA_TO_GRAM			0x22
> +#define REG_RAM_WRITE_MASK1			0x23
> +#define REG_RAM_WRITE_MASK2			0x24
> +#define REG_GAMMA_CONTROL_1			0x30
> +#define REG_GAMMA_CONTROL_2			0x31
> +#define REG_GAMMA_CONTROL_3			0x32
> +#define REG_GAMMA_CONTROL_4			0x33
> +#define REG_GAMMA_CONTROL_5			0x34
> +#define REG_GAMMA_CONTROL_6			0x35
> +#define REG_GAMMA_CONTROL_7			0x36
> +#define REG_GAMMA_CONTROL_8			0x37
> +#define REG_GAMMA_CONTROL_9			0x38
> +#define REG_GAMMA_CONTROL_10			0x39
> +#define REG_GATE_SCAN_CONTROL			0x40
> +#define REG_VERT_SCROLL_CONTROL			0x41
> +#define REG_FIRST_SCREEN_DRIVE_POS		0x42
> +#define REG_SECOND_SCREEN_DRIVE_POS		0x43
> +#define REG_RAM_ADDR_POS_H			0x44
> +#define REG_RAM_ADDR_POS_V			0x45
> +#define REG_OSCILLATOR_CONTROL			0x4F
> +#define REG_GPIO				0x60
> +#define REG_OTP_VCM_PROGRAMMING			0x61
> +#define REG_OTP_VCM_STATUS_ENABLE		0x62
> +#define REG_OTP_PROGRAMMING_ID_KEY		0x65
> +
> +/*
> + * maximum frequency for register access
> + * (not for the GRAM access)
> + */
> +#define ILITEK_MAX_FREQ_REG	4000000
> +
> +/*
> + * Device ID as found in the datasheet (supports 9221 and 9222)
> + */
> +#define ILITEK_DEVICE_ID	0x9220
> +#define ILITEK_DEVICE_ID_MASK	0xFFF0
> +
> +/* Last two bits in the START BYTE */
> +#define START_RS_INDEX		0
> +#define START_RS_REG		1
> +#define START_RW_WRITE		0
> +#define START_RW_READ		1
> +
> +/**
> + * START_BYTE(id, rs, rw)
> + *
> + * Set the start byte according to the required operation.
> + * The start byte is defined as:
> + *   ----------------------------------
> + *  | 0 | 1 | 1 | 1 | 0 | ID | RS | RW |
> + *   ----------------------------------
> + * @id: display's id as set by the manufacturer
> + * @rs: operation type bit, one of:
> + *	  - START_RS_INDEX	set the index register
> + *	  - START_RS_REG	write/read registers/GRAM
> + * @rw: read/write operation
> + *	 - START_RW_WRITE	write
> + *	 - START_RW_READ	read
> + */
> +#define START_BYTE(id, rs, rw)	\
> +	(0x70 | (((id) & 0x01) << 2) | (((rs) & 0x01) << 1) | ((rw) & 0x01))
> +
> +/**
> + * CHECK_FREQ_REG(spi_device s, spi_transfer x) - Check the frequency
> + *	for the SPI transfer. According to the datasheet, the controller
> + *	accept higher frequency for the GRAM transfer, but it requires
> + *	lower frequency when the registers are read/written.
> + *	The macro sets the frequency in the spi_transfer structure if
> + *	the frequency exceeds the maximum value.
> + */
> +#define CHECK_FREQ_REG(s, x)	\
> +	do {			\
> +		if (s->max_speed_hz > ILITEK_MAX_FREQ_REG)	\
> +			((struct spi_transfer *)x)->speed_hz =	\
> +					ILITEK_MAX_FREQ_REG;	\
> +	} while (0)
> +
> +#define CMD_BUFSIZE		16
> +
> +#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
> +
> +#define set_tx_byte(b)		(tx_invert ? ~(b) : b)
> +
> +/**
> + * ili922x_id - id as set by manufacturer
> + */
> +static int ili922x_id = 1;
> +module_param(ili922x_id, int, 0);
> +
> +static int tx_invert;
> +module_param(tx_invert, int, 0);
> +
> +/**
> + * driver's private structure
> + */
> +struct ili922x {
> +	struct spi_device *spi;
> +	struct lcd_device *ld;
> +	int power;
> +};
> +
> +#define NUM_DUMMY_BYTES		1
> +static void send_dummy(struct spi_device *spi)
> +{
> +	struct spi_message m;
> +	struct spi_transfer xfer;
> +	unsigned char tbuf[CMD_BUFSIZE];
> +	unsigned char rbuf[CMD_BUFSIZE];
> +	int ret = 0, i;
> +
> +	return;
> +
> +	memset(&xfer, 0, sizeof(struct spi_transfer));
> +	spi_message_init(&m);
> +	xfer.tx_buf = tbuf;
> +	xfer.rx_buf = rbuf;
> +	xfer.cs_change = 1;
> +	CHECK_FREQ_REG(spi, &xfer);
> +
> +	for (i = 0; i < NUM_DUMMY_BYTES; i++)
> +		tbuf[i] = set_tx_byte(0xFF);
> +
> +	xfer.bits_per_word = 8;
> +	xfer.len = NUM_DUMMY_BYTES;
> +	spi_message_add_tail(&xfer, &m);
> +	ret = spi_sync(spi, &m);
> +
> +	udelay(10);

How about replacing udelay() with usleep_range()?

> +}
> +
> +/**
> + * read_status - read status register from display
> + * @spi: spi device
> + */
> +static u16 read_status(struct spi_device *spi)
> +{
> +	struct spi_message m;

Would you replace 'm' with 'msg' or 'message' for the readability?
It's too short, even though 'm' is used in include/linux/spi/spi.h.

	struct spi_message msg;

> +	struct spi_transfer xfer;
> +	unsigned char tbuf[CMD_BUFSIZE];
> +	unsigned char rbuf[CMD_BUFSIZE];
> +	int ret = 0, i;
> +
> +	send_dummy(spi);
> +
> +	memset(&xfer, 0, sizeof(struct spi_transfer));
> +	spi_message_init(&m);
> +	xfer.tx_buf = tbuf;
> +	xfer.rx_buf = rbuf;
> +	xfer.cs_change = 1;
> +	CHECK_FREQ_REG(spi, &xfer);
> +
> +	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_INDEX,
> +					 START_RW_READ));
> +	for (i = 1; i < 4; i++)
> +		tbuf[i] = set_tx_byte(0);	/* dummy */
> +
> +	xfer.bits_per_word = 8;
> +	xfer.len = 4;
> +	spi_message_add_tail(&xfer, &m);
> +	ret = spi_sync(spi, &m);
> +
> +	return (rbuf[2] << 8) + rbuf[3];
> +}
> +
> +/**
> + * read_reg - read register from display
> + * @spi: spi device
> + * @reg: offset of the register to be read
> + * @rx:  output value
> + */
> +static int read_reg(struct spi_device *spi, u8 reg, u16 *rx)
> +{
> +	struct spi_message m;
> +	struct spi_transfer xfer_regindex, xfer_regvalue;
> +	unsigned char tbuf[CMD_BUFSIZE];
> +	unsigned char rbuf[CMD_BUFSIZE];
> +	int ret = 0, len = 0, i, send_bytes;
> +
> +	send_dummy(spi);
> +
> +	memset(&xfer_regindex, 0, sizeof(struct spi_transfer));
> +	memset(&xfer_regvalue, 0, sizeof(struct spi_transfer));
> +	spi_message_init(&m);
> +	xfer_regindex.tx_buf = tbuf;
> +	xfer_regindex.rx_buf = rbuf;
> +	xfer_regindex.cs_change = 1;
> +	CHECK_FREQ_REG(spi, &xfer_regindex);
> +
> +	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_INDEX,
> +					 START_RW_WRITE));
> +	tbuf[1] = set_tx_byte(0);
> +	tbuf[2] = set_tx_byte(reg);
> +	xfer_regindex.bits_per_word = 8;
> +	len = xfer_regindex.len = 3;
> +	spi_message_add_tail(&xfer_regindex, &m);
> +
> +	send_bytes = len;
> +
> +	tbuf[len++] = set_tx_byte(START_BYTE(ili922x_id, START_RS_REG,
> +					     START_RW_READ));
> +	for (i = len; i < CMD_BUFSIZE; i++)
> +		tbuf[i] = set_tx_byte(0);	/* dummy */
> +
> +	xfer_regvalue.cs_change = 1;
> +	xfer_regvalue.len = 4;

I don't understand why length 4 is necessary.
In my opinion, length 3 seems to be enough.
- tbuf[4] is used for sending 'START_BYTE(ili922x_id, START_RS_REG, START_RW_READ)'.
- rbuf[5] and rbuf[6] are used for receiving value as below.
   *rx = (rbuf[1 + send_bytes] << 8) + rbuf[2 + send_bytes];

However, tbuf[7] or rbuf[7] seems to be unnecessary.
If I'm wrong, please let me know kindly.


> +	xfer_regvalue.tx_buf = &tbuf[send_bytes];
> +	xfer_regvalue.rx_buf = &rbuf[send_bytes];
> +	CHECK_FREQ_REG(spi, &xfer_regvalue);
> +
> +	spi_message_add_tail(&xfer_regvalue, &m);
> +	ret = spi_sync(spi, &m);
> +	if (ret < 0) {
> +		dev_dbg(&spi->dev, "Error sending SPI message 0x%x", ret);
> +		return ret;
> +	}
> +
> +	*rx = (rbuf[1 + send_bytes] << 8) + rbuf[2 + send_bytes];
> +	return 0;
> +}
> +
> +/**
> + * write_reg - write a controller register
> + * @spi: struct spi_device *
> + * @reg: offset of the register to be written
> + * @value: value to be written
> + */
> +static int write_reg(struct spi_device *spi, u8 reg, u16 value)
> +{
> +	struct spi_message m;
> +	struct spi_transfer xfer_regindex, xfer_regvalue;
> +	unsigned char tbuf[CMD_BUFSIZE];
> +	unsigned char rbuf[CMD_BUFSIZE];
> +	int ret = 0, len = 0;
> +
> +	send_dummy(spi);
> +
> +	memset(&xfer_regindex, 0, sizeof(struct spi_transfer));
> +	memset(&xfer_regvalue, 0, sizeof(struct spi_transfer));
> +
> +	spi_message_init(&m);
> +	xfer_regindex.tx_buf = tbuf;
> +	xfer_regindex.rx_buf = rbuf;
> +	xfer_regindex.cs_change = 1;
> +	CHECK_FREQ_REG(spi, &xfer_regindex);
> +
> +	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_INDEX,
> +					 START_RW_WRITE));
> +	tbuf[1] = set_tx_byte(0);
> +	tbuf[2] = set_tx_byte(reg);
> +	xfer_regindex.bits_per_word = 8;
> +	xfer_regindex.len = 3;
> +	spi_message_add_tail(&xfer_regindex, &m);
> +
> +	ret = spi_sync(spi, &m);
> +
> +	send_dummy(spi);
> +
> +	spi_message_init(&m);
> +	len = 0;
> +	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_REG,
> +					 START_RW_WRITE));
> +	tbuf[1] = set_tx_byte((value & 0xFF00) >> 8);
> +	tbuf[2] = set_tx_byte(value & 0x00FF);
> +
> +	xfer_regvalue.cs_change = 1;
> +	xfer_regvalue.len = 3;
> +	xfer_regvalue.tx_buf = tbuf;
> +	xfer_regvalue.rx_buf = rbuf;
> +	CHECK_FREQ_REG(spi, &xfer_regvalue);
> +
> +	spi_message_add_tail(&xfer_regvalue, &m);
> +
> +	ret = spi_sync(spi, &m);
> +	if (ret < 0) {
> +		dev_err(&spi->dev, "Error sending SPI message 0x%x", ret);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +#ifdef DEBUG
> +/**
> + * ili922x_reg_dump - dump all registers
> + */
> +static void ili922x_reg_dump(struct spi_device *spi)
> +{
> +	u8 reg;
> +	u16 rx;
> +
> +	pr_info("ILI922x configuration registers:\n");

Please replace pr_info() with dev_info() as below.

	dev_err(&spi->dev, "ILI922x configuration registers:\n");

> +	for (reg = REG_START_OSCILLATION;
> +	     reg <= REG_OTP_PROGRAMMING_ID_KEY; reg++) {
> +		read_reg(spi, reg, &rx);
> +		pr_info("reg @ 0x%02X: 0x%04X\n", reg, rx);

Same as above.

> +	}
> +}
> +#else
> +static inline void ili922x_reg_dump(struct spi_device *spi) {}
> +#endif
> +
> +/**
> + * set_write_to_gram_reg - initialize the display to write the GRAM
> + * @spi: spi device
> + */
> +static void set_write_to_gram_reg(struct spi_device *spi)
> +{
> +	struct spi_message m;
> +	struct spi_transfer xfer;
> +	unsigned char tbuf[CMD_BUFSIZE];
> +
> +	memset(&xfer, 0, sizeof(struct spi_transfer));
> +
> +	spi_message_init(&m);
> +	xfer.tx_buf = tbuf;
> +	xfer.rx_buf = NULL;
> +	xfer.cs_change = 1;
> +
> +	tbuf[0] = START_BYTE(ili922x_id, START_RS_INDEX, START_RW_WRITE);
> +	tbuf[1] = 0;
> +	tbuf[2] = REG_WRITE_DATA_TO_GRAM;
> +
> +	xfer.bits_per_word = 8;
> +	xfer.len = 3;
> +	spi_message_add_tail(&xfer, &m);
> +	spi_sync(spi, &m);
> +}
> +
> +/**
> + * ili922x_poweron - turn the display on
> + * @spi: spi device
> + *
> + * The sequence to turn on the display is taken from
> + * the datasheet and/or the example code provided by the
> + * manufacturer.
> + */
> +static int ili922x_poweron(struct spi_device *spi)
> +{
> +	int ret = 0;

Initialization is not necessary.
Just declare it as below:
	int ret;

> +
> +	/* Power on */
> +	ret = write_reg(spi, REG_POWER_CONTROL_1, 0x0000);
> +	mdelay(10);
> +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0000);
> +	mdelay(40);
> +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x0000);
> +	mdelay(40);
> +	ret += write_reg(spi, 0x56, 0x080F);

Would you replace this hard-coded address with the bit definition?


> +	ret += write_reg(spi, REG_POWER_CONTROL_1, 0x4240);
> +	mdelay(10);
> +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0014);
> +	mdelay(40);
> +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x1319);
> +	mdelay(40);

How about replacing mdelay() with msleep()?

> +
> +	return ret;
> +}
> +
> +/**
> + * ili922x_poweroff - turn the display off
> + * @spi: spi device
> + */
> +static int ili922x_poweroff(struct spi_device *spi)
> +{
> +	int ret = 0;

Initialization is not necessary.
Just declare it as below:
	int ret;


> +
> +	/* Power off */
> +	ret = write_reg(spi, REG_POWER_CONTROL_1, 0x0000);
> +	mdelay(10);
> +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0000);
> +	mdelay(40);
> +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x0000);
> +	mdelay(40);

Same as above.

> +
> +	return ret;
> +}
> +
> +/**
> + * ili922x_display_init - initialize the display by setting
> + *			  the configuration registers
> + * @spi: spi device
> + */
> +static void ili922x_display_init(struct spi_device *spi)
> +{
> +	write_reg(spi, REG_START_OSCILLATION, 1);
> +	mdelay(10);

Same as above.

> +	write_reg(spi, REG_DRIVER_OUTPUT_CONTROL, 0x691B);
> +	write_reg(spi, REG_LCD_AC_DRIVEING_CONTROL, 0x0700);
> +	write_reg(spi, REG_ENTRY_MODE, 0x1030);
> +	write_reg(spi, REG_COMPARE_1, 0x0000);
> +	write_reg(spi, REG_COMPARE_2, 0x0000);
> +	write_reg(spi, REG_DISPLAY_CONTROL_1, 0x0037);
> +	write_reg(spi, REG_DISPLAY_CONTROL_2, 0x0202);
> +	write_reg(spi, REG_DISPLAY_CONTROL_3, 0x0000);
> +	write_reg(spi, REG_FRAME_CYCLE_CONTROL, 0x0000);
> +
> +	/* Set RGB interface */
> +	write_reg(spi, REG_EXT_INTF_CONTROL, 0x0110);
> +
> +	ili922x_poweron(spi);
> +
> +	write_reg(spi, REG_GAMMA_CONTROL_1, 0x0302);
> +	write_reg(spi, REG_GAMMA_CONTROL_2, 0x0407);
> +	write_reg(spi, REG_GAMMA_CONTROL_3, 0x0304);
> +	write_reg(spi, REG_GAMMA_CONTROL_4, 0x0203);
> +	write_reg(spi, REG_GAMMA_CONTROL_5, 0x0706);
> +	write_reg(spi, REG_GAMMA_CONTROL_6, 0x0407);
> +	write_reg(spi, REG_GAMMA_CONTROL_7, 0x0706);
> +	write_reg(spi, REG_GAMMA_CONTROL_8, 0x0000);
> +	write_reg(spi, REG_GAMMA_CONTROL_9, 0x0C06);
> +	write_reg(spi, REG_GAMMA_CONTROL_10, 0x0F00);
> +	write_reg(spi, REG_RAM_ADDRESS_SET, 0x0000);
> +	write_reg(spi, REG_GATE_SCAN_CONTROL, 0x0000);
> +	write_reg(spi, REG_VERT_SCROLL_CONTROL, 0x0000);
> +	write_reg(spi, REG_FIRST_SCREEN_DRIVE_POS, 0xDB00);
> +	write_reg(spi, REG_SECOND_SCREEN_DRIVE_POS, 0xDB00);
> +	write_reg(spi, REG_RAM_ADDR_POS_H, 0xAF00);
> +	write_reg(spi, REG_RAM_ADDR_POS_V, 0xDB00);
> +	ili922x_reg_dump(spi);
> +	set_write_to_gram_reg(spi);
> +}
> +
> +static int ili922x_lcd_power(struct ili922x *lcd, int power)
> +{
> +	int ret = 0;
> +
> +	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
> +		ret = ili922x_poweron(lcd->spi);
> +	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
> +		ret = ili922x_poweroff(lcd->spi);
> +
> +	if (!ret)
> +		lcd->power = power;
> +
> +	return ret;
> +}
> +
> +static int ili922x_set_power(struct lcd_device *ld, int power)
> +{
> +	struct ili922x *ili = lcd_get_data(ld);
> +
> +	return ili922x_lcd_power(ili, power);
> +}
> +
> +static int ili922x_get_power(struct lcd_device *ld)
> +{
> +	struct ili922x *ili = lcd_get_data(ld);
> +
> +	return ili->power;
> +}
> +
> +static struct lcd_ops ili922x_ops = {
> +	.get_power = ili922x_get_power,
> +	.set_power = ili922x_set_power,
> +};
> +
> +static int ili922x_probe(struct spi_device *spi)
> +{
> +	struct ili922x *ili;
> +	struct lcd_device *lcd;
> +	int ret;
> +	u16 reg = 0;
> +
> +	ili = devm_kzalloc(&spi->dev, sizeof(*ili), GFP_KERNEL);
> +	if (!ili) {
> +		dev_err(&spi->dev, "cannot alloc priv data\n");
> +		return -ENOMEM;
> +	}
> +
> +	ili->spi = spi;
> +	dev_set_drvdata(&spi->dev, ili);
> +
> +	/* check if the device is connected */
> +	ret = read_reg(spi, REG_DRIVER_CODE_READ, &reg);
> +	if (ret || ((reg & ILITEK_DEVICE_ID_MASK) != ILITEK_DEVICE_ID)) {
> +		dev_err(&spi->dev,
> +			"no LCD found: Chip ID 0x%x, ret %d\n",
> +			reg, ret);
> +		return -ENODEV;
> +	} else {
> +		dev_info(&spi->dev, "ILI%x found, SPI freq %d, mode %d\n",
> +			 reg, spi->max_speed_hz, spi->mode);
> +	}
> +
> +	dev_dbg(&spi->dev, "status: 0x%x\n", read_status(spi));
> +
> +	ili922x_display_init(spi);
> +
> +	ili->power = FB_BLANK_POWERDOWN;
> +
> +	lcd = lcd_device_register("ili922xlcd", &spi->dev, ili,
> +				  &ili922x_ops);
> +	if (IS_ERR(lcd)) {
> +		dev_err(&spi->dev, "cannot register LCD\n");
> +		return PTR_ERR(lcd);
> +	}
> +
> +	ili->ld = lcd;
> +	spi_set_drvdata(spi, ili);
> +
> +	ili922x_lcd_power(ili, FB_BLANK_UNBLANK);
> +
> +	return 0;
> +}
> +
> +static int ili922x_remove(struct spi_device *spi)
> +{
> +	struct ili922x *ili = spi_get_drvdata(spi);
> +
> +	ili922x_poweroff(spi);
> +	lcd_device_unregister(ili->ld);
> +	return 0;
> +}
> +
> +static struct spi_driver ili922x_driver = {
> +	.driver = {
> +		.name = "ili922x",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = ili922x_probe,
> +	.remove = ili922x_remove,
> +};
> +
> +module_spi_driver(ili922x_driver);
> +
> +MODULE_AUTHOR("Stefano Babic <sbabic@denx.de>");
> +MODULE_DESCRIPTION("ILI9221/9222 LCD driver");
> +MODULE_LICENSE("GPL");
> +MODULE_PARM_DESC(ili922x_id, "set controller identifier (default=1)");
> +MODULE_PARM_DESC(tx_invert, "invert bytes before sending");
> --
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

