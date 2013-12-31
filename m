Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LaDjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 22:39:13 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38435 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3LaDiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 22:38:51 -0500
Message-ID: <52C23C41.6090003@lwfinger.net>
Date: Mon, 30 Dec 2013 21:38:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tim Jester-Pfadt <t.jp@gmx.de>, gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu: Fixed coding style issues
References: <1388458437-25362-1-git-send-email-t.jp@gmx.de>
In-Reply-To: <1388458437-25362-1-git-send-email-t.jp@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2013 08:53 PM, Tim Jester-Pfadt wrote:
> Fixed required and prohibited spaces to make rtw_io.h checkpatch.pl clean
>
> Signed-off-by: Tim Jester-Pfadt <t.jp@gmx.de>
> ---
>   drivers/staging/rtl8188eu/include/rtw_io.h | 36 +++++++++++++++---------------
>   1 file changed, 18 insertions(+), 18 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
> index eb6f0e5..3d1dfcc 100644
> --- a/drivers/staging/rtl8188eu/include/rtw_io.h
> +++ b/drivers/staging/rtl8188eu/include/rtw_io.h
> @@ -123,7 +123,7 @@ struct _io_ops {
>   			  u8 *pmem);
>   	u32 (*_write_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
>   			   u8 *pmem);
> -	u32 (*_write_scsi)(struct intf_hdl *pintfhdl,u32 cnt, u8 *pmem);
> +	u32 (*_write_scsi)(struct intf_hdl *pintfhdl, u32 cnt, u8 *pmem);
>   	void (*_read_port_cancel)(struct intf_hdl *pintfhdl);
>   	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
>   };
> @@ -213,7 +213,7 @@ struct reg_protocol_wt {
>   	u32	Value;
>   #else
>   	/* DW1 */
> -	u32 Reserved1 :4;
> +	u32 Reserved1:4;
>   	u32 NumOfTrans:4;
>   	u32 Reserved2:24;
>   	/* DW2 */
> @@ -254,7 +254,7 @@ struct io_priv {
>   };
>
>   uint ioreq_flush(struct adapter *adapter, struct io_queue *ioqueue);
> -void sync_ioreq_enqueue(struct io_req *preq,struct io_queue *ioqueue);
> +void sync_ioreq_enqueue(struct io_req *preq, struct io_queue *ioqueue);
>   uint sync_ioreq_flush(struct adapter *adapter, struct io_queue *ioqueue);
>   uint free_ioreq(struct io_req *preq, struct io_queue *pio_queue);
>   struct io_req *alloc_ioreq(struct io_queue *pio_q);
> @@ -368,20 +368,20 @@ void free_io_queue(struct adapter *adapter);
>   void async_bus_io(struct io_queue *pio_q);
>   void bus_sync_io(struct io_queue *pio_q);
>   u32 _ioreq2rwmem(struct io_queue *pio_q);
> -void dev_power_down(struct adapter * Adapter, u8 bpwrup);
> -
> -#define PlatformEFIOWrite1Byte(_a,_b,_c)		\
> -	rtw_write8(_a,_b,_c)
> -#define PlatformEFIOWrite2Byte(_a,_b,_c)		\
> -	rtw_write16(_a,_b,_c)
> -#define PlatformEFIOWrite4Byte(_a,_b,_c)		\
> -	rtw_write32(_a,_b,_c)
> -
> -#define PlatformEFIORead1Byte(_a,_b)		\
> -		rtw_read8(_a,_b)
> -#define PlatformEFIORead2Byte(_a,_b)		\
> -		rtw_read16(_a,_b)
> -#define PlatformEFIORead4Byte(_a,_b)		\
> -		rtw_read32(_a,_b)
> +void dev_power_down(struct adapter *Adapter, u8 bpwrup);
> +
> +#define PlatformEFIOWrite1Byte(_a, _b, _c)		\
> +	rtw_write8(_a, _b, _c)
> +#define PlatformEFIOWrite2Byte(_a, _b, _c)		\
> +	rtw_write16(_a, _b, _c)
> +#define PlatformEFIOWrite4Byte(_a, _b, _c)		\
> +	rtw_write32(_a, _b, _c)
> +
> +#define PlatformEFIORead1Byte(_a, _b)		\
> +		rtw_read8(_a, _b)
> +#define PlatformEFIORead2Byte(_a, _b)		\
> +		rtw_read16(_a, _b)
> +#define PlatformEFIORead4Byte(_a, _b)		\
> +		rtw_read32(_a, _b)
>
>   #endif	/* _RTL8711_IO_H_ */
>

