Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3CFIoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:44:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63904 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3CFIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:44:25 -0500
X-AuditID: cbfee690-b7f6b6d000004563-42-513701e77646
Message-id: <51370206.7000608@samsung.com>
Date: Wed, 06 Mar 2013 17:44:54 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Benson Leung <bleung@chromium.org>
Cc: olofj@chromium.org, miletus@chromium.org, dmitry.torokhov@gmail.com,
        matthew.garrett@nebula.com, rydberg@euromail.se, djkurtz@chromium.org,
        wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: Re: [PATCH v2 1/2] Input: atmel_mxt_ts - add device id for touchpad
 variant
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
 <1362555707-24654-1-git-send-email-bleung@chromium.org>
 <1362555707-24654-2-git-send-email-bleung@chromium.org>
In-reply-to: <1362555707-24654-2-git-send-email-bleung@chromium.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zbd3njOaBBvP+mVlMf3KZxaJxxnxW
	i8OLXjBa3Pz0jdXi8q45bBYfP9lYPL6zksni9Idki69bdjNarN7zgtliyvSZjBar/p9lceDx
	mN1wkcXjwOSbbB47Z91l9zj8oZXFY+GVZiaPz5vkPF4cf8kUwB7FZZOSmpNZllqkb5fAlXF9
	wlLGgmcGFe1fnzI3MN5R62Lk4JAQMJF4sZ+vi5ETyBSTuHBvPVsXIxeHkMAyRollj1ezQSRM
	JF4desgIkZjOKNE0o5kFwnnJKNFzZwsLyCReAS2J6YfCQBpYBFQlNj6aCNbMJqAncWfbcSYQ
	W1QgTGLl9CssIDavgKDEj8n3wGwRATWJye07WUFmMgusZpK4fuANI0hCGKjh1NqvrBDLtjFK
	3G58zAyS4BRwkbizrIsdxGYWsJZYOWkbI4QtL7F5zVtmkAYJgVYOiRmztjNDnCQg8W3yIRaI
	n2UlNh1ghnhNUuLgihssExjFZiE5ahaSsbOQjF3AyLyKUTS1ILmgOCm9yESvODG3uDQvXS85
	P3cTIyR2J+xgvHfA+hBjMtDKicxSosn5wNjPK4k3NDYwNjS0NDQztTQ1IE1YSZxX/pJMoJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQZG6e8dGamnRII2hi/es//WqYMfkjl2hMwtVxX4lSZm
	WJ0c6XZtikTSo8BtFSJMznyXzxduWG58YEXhktUSfXl6/Yfin3+YHC+Z3Blx44vM4Q/rWJ8o
	13UKTegqZ9SRXcqX6/Q1rf5Q71q+y9KtF7c79K5mTS8OZT80x+rT5UoZRcZJHZ/FDtQpsRRn
	JBpqMRcVJwIAyzLl7PMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd3njOaBBo8n6FtMf3KZxaJxxnxW
	i8OLXjBa3Pz0jdXi8q45bBYfP9lYPL6zksni9Idki69bdjNarN7zgtliyvSZjBar/p9lceDx
	mN1wkcXjwOSbbB47Z91l9zj8oZXFY+GVZiaPz5vkPF4cf8kUwB7VwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwjjHj+oSljAXPDCravz5lbmC8o9bFyMkhIWAi8erQQ0YIW0zi
	wr31bF2MXBxCAtMZJZpmNLNAOC8ZJXrubAFyODh4BbQkph8KA2lgEVCV2PhoIhuIzSagJ3Fn
	23EmEFtUIExi5fQrLCA2r4CgxI/J98BsEQE1icntO1lBZjILrGaSuH7gDdhmYaCGU2u/skIs
	28YocbvxMTNIglPAReLOsi52EJtZwFpi5aRtjBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9i
	FE0tSC4oTkrPNdQrTswtLs1L10vOz93ECE4Nz6R2MK5ssDjEKMDBqMTDa6FkFijEmlhWXJl7
	iFGCg1lJhJfrDFCINyWxsiq1KD++qDQntfgQYzIwDCYyS4km5wPTVl5JvKGxiZmRpZGZsYm5
	sTFpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYGQpmlgXeWNefJqo3feGgrUVU1PL/fU8
	37lqcZydlpXq5bq2VGTFoV3qzwqabmQd1ljZbuajy7tGblU+o9fZgxMPxRh7qpfxn43P333g
	RAyD3nWWRo7G/N1rguOnvDTIuBhX8uMWT23Phx9nfRXmFG3gv1UTFffoYvSe53KGDewsEQKz
	ZPbvVmIpzkg01GIuKk4EAIE3UHdRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

On 03/06/2013 04:41 PM, Benson Leung wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
>
> This same driver can be used by atmel based touchscreens and touchpads
> (buttonpads) by instantiating the i2c device as a "atmel_mxt_tp".
>
> This will cause the driver to perform some touchpad specific
> initializations, such as:
>    * register input device name "Atmel maXTouch Touchpad" instead of
>    Touchscreen.
>    * register BTN_LEFT & BTN_TOOL_* event types.
>    * register axis resolution (as a fixed constant, for now)
>    * register BUTTONPAD property
>    * process GPIO buttons using reportid T19
>
> For now, the left mouse button is mapped to GPIO3. Going forward,
> platform data should specify the configuration of the buttons.
> They can be configured via a future platform data change to
> specify optional middle and right buttons, as well as other possible
> uses for the GPIO object T19.

It's better to implement this now.

> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Tested-by: Olof Johansson <olof@lixom.net>
> ---
> v2: zero reportid in mxt_object_table_free(), Thanks nick.dyer@itdev.co.uk
> v1: Initial
> ---
>   drivers/input/touchscreen/atmel_mxt_ts.c | 57 ++++++++++++++++++++++++++++++--
>   1 file changed, 55 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index d04f810..3611a26 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -181,6 +181,12 @@
>   
>   #define MXT_FWRESET_TIME	175	/* msec */
>   
> +/* MXT_SPT_GPIOPWM_T19 field */
> +#define MXT_GPIO0_MASK		0x04
> +#define MXT_GPIO1_MASK		0x08
> +#define MXT_GPIO2_MASK		0x10
> +#define MXT_GPIO3_MASK		0x20
> +
>   /* Command to unlock bootloader */
>   #define MXT_UNLOCK_CMD_MSB	0xaa
>   #define MXT_UNLOCK_CMD_LSB	0xdc
> @@ -212,6 +218,8 @@
>   /* Touchscreen absolute values */
>   #define MXT_MAX_AREA		0xff
>   
> +#define MXT_PIXELS_PER_MM	20
> +
>   struct mxt_info {
>   	u8 family_id;
>   	u8 variant_id;
> @@ -243,6 +251,8 @@ struct mxt_data {
>   	const struct mxt_platform_data *pdata;
>   	struct mxt_object *object_table;
>   	struct mxt_info info;
> +	bool is_tp;
> +
>   	unsigned int irq;
>   	unsigned int max_x;
>   	unsigned int max_y;
> @@ -251,6 +261,7 @@ struct mxt_data {
>   	u8 T6_reportid;
>   	u8 T9_reportid_min;
>   	u8 T9_reportid_max;
> +	u8 T19_reportid;
>   };
>   
>   static bool mxt_object_readable(unsigned int type)
> @@ -502,6 +513,18 @@ static int mxt_write_object(struct mxt_data *data,
>   	return mxt_write_reg(data->client, reg + offset, val);
>   }
>   
> +static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
> +{
> +	struct device *dev = &data->client->dev;
> +	struct input_dev *input = data->input_dev;
> +	bool button;
> +
> +	/* Active-low switch */
> +	button = !(message->message[0] & MXT_GPIO3_MASK);
> +	input_report_key(input, BTN_LEFT, button);
> +	dev_dbg(dev, "Button state: %d\n", button);
> +}
> +
>   static void mxt_input_touchevent(struct mxt_data *data,
>   				      struct mxt_message *message, int id)
>   {
> @@ -585,6 +608,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
>   			int id = reportid - data->T9_reportid_min;
>   			mxt_input_touchevent(data, &message, id);
>   			update_input = true;
> +		} else if (message.reportid == data->T19_reportid) {
> +			mxt_input_button(data, &message);
> +			update_input = true;
>   		} else {
>   			mxt_dump_message(dev, &message);
>   		}
> @@ -764,6 +790,9 @@ static int mxt_get_object_table(struct mxt_data *data)
>   			data->T9_reportid_min = min_id;
>   			data->T9_reportid_max = max_id;
>   			break;
> +		case MXT_SPT_GPIOPWM_T19:
> +			data->T19_reportid = min_id;
> +			break;
>   		}
>   	}
>   
> @@ -777,7 +806,7 @@ static void mxt_free_object_table(struct mxt_data *data)
>   	data->T6_reportid = 0;
>   	data->T9_reportid_min = 0;
>   	data->T9_reportid_max = 0;
> -
> +	data->T19_reportid = 0;
>   }
>   
>   static int mxt_initialize(struct mxt_data *data)
> @@ -1115,9 +1144,13 @@ static int mxt_probe(struct i2c_client *client,
>   		goto err_free_mem;
>   	}
>   
> -	input_dev->name = "Atmel maXTouch Touchscreen";
> +	data->is_tp = !strcmp(id->name, "atmel_mxt_tp");
> +
> +	input_dev->name = (data->is_tp) ? "Atmel maXTouch Touchpad" :
> +					  "Atmel maXTouch Touchscreen";
>   	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
>   		 client->adapter->nr, client->addr);
> +
>   	input_dev->phys = data->phys;
>   
>   	input_dev->id.bustype = BUS_I2C;
> @@ -1140,6 +1173,25 @@ static int mxt_probe(struct i2c_client *client,
>   	__set_bit(EV_KEY, input_dev->evbit);
>   	__set_bit(BTN_TOUCH, input_dev->keybit);
>   
> +	if (data->is_tp) {
> +		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
> +		__set_bit(INPUT_PROP_BUTTONPAD, input_dev->propbit);
> +
> +		__set_bit(BTN_LEFT, input_dev->keybit);
> +		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
> +		__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
> +		__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
> +		__set_bit(BTN_TOOL_QUADTAP, input_dev->keybit);
> +		__set_bit(BTN_TOOL_QUINTTAP, input_dev->keybit);
> +
> +		input_abs_set_res(input_dev, ABS_X, MXT_PIXELS_PER_MM);
> +		input_abs_set_res(input_dev, ABS_Y, MXT_PIXELS_PER_MM);
> +		input_abs_set_res(input_dev, ABS_MT_POSITION_X,
> +				  MXT_PIXELS_PER_MM);
> +		input_abs_set_res(input_dev, ABS_MT_POSITION_Y,
> +				  MXT_PIXELS_PER_MM);
> +	}
> +
>   	/* For single touch */
>   	input_set_abs_params(input_dev, ABS_X,
>   			     0, data->max_x, 0, 0);
> @@ -1258,6 +1310,7 @@ static SIMPLE_DEV_PM_OPS(mxt_pm_ops, mxt_suspend, mxt_resume);
>   static const struct i2c_device_id mxt_id[] = {
>   	{ "qt602240_ts", 0 },
>   	{ "atmel_mxt_ts", 0 },
> +	{ "atmel_mxt_tp", 0 },

How about driver_data to distinguish touchscreen and touchpad?

>   	{ "mXT224", 0 },
>   	{ }
>   };

