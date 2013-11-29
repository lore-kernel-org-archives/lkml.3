Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3K2E1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:27:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24485 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3K2E1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:27:33 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-37-529817b3b7ef
Date: Fri, 29 Nov 2013 04:27:31 +0000 (GMT)
From: Anurag Aggarwal <a.anurag@samsung.com>
Subject: Re: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow
 in unwind_exec_insn Signed-off-by: Anurag Aggarwal <a.anurag@samsung.com>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Anurag Aggarwal <a.anurag@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Naveen Kumar <naveen.sel@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Mohammad Irfan Ansari <mohammad.a2@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ashish Kalra <ashish.kalra@samsung.com>, "cpgs ." <cpgs@samsung.com>,
        "anurag19aggarwal@gmail.com" <anurag19aggarwal@gmail.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        Rajat Suri <rajat.suri@samsung.com>,
        Poorva Srivastava <poorva.s@samsung.com>,
        Narendra Meher <narendra.m1@samsung.com>
Reply-to: a.anurag@samsung.com
MIME-version: 1.0
X-MTR: 20131129042640896@a.anurag
Msgkey: 20131129042640896@a.anurag
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131129042640896@a.anurag
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: Y
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <26792240.155131385699248305.JavaMail.weblogic@epml16>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSpLtZfEaQwYXP6haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj/+Ml7AX/rCo+/eljbGDcYdnFyMkhJKAs0bt3PRuILSFgIrH+
	835WCFtM4sI9kDgXUM1SRomHlz8BORxgRUtv1kDE5zNKnNnzhQmkgUVAVeLH5DNgg9gEdCUm
	3rjCDGILC8xglNh6yRakV0RAXeLoPkuQXmaB1WwSG3tXMkMcISdxd912MJtXQFDi5MwnLBBH
	KErM+/qRFSKuJLH75k12iLicxJKpl5kgbF6JGe1PWWDi076uYYawpSXOz9rACPPM4u+PoeL8
	Esdu72CC+IVX4sn9YJgxuzd/gYaDgMTUMwehWtUkbqx/DWXzSaxZ+JYFZsyuU8uZYXobNv4G
	O40Z6OQp3Q+hbAOJI4vmsKJ7i1fASeLwx//MExiVZyFJzULSPgtJO7KaBYwsqxhFUwuSC4qT
	0osM9YoTc4tL89L1kvNzNzEC08Lpf896dzDePmB9iDEZGCUTmaVEk/OBaSWvJN7Q2MzIwtTE
	1NjI3NKMNGElcd6kh0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgz2ea3OTDc+nGQW/Wu
	u4jnoUd6S7ycFu6Qt/T2Sj3rsUdp6exfYn8V/fY4L8p/VrxOdOLlW223l24ULVi25NnvjUuM
	M7Jt704XDmxnletcH7Hvh6+MqZW839H5Aen5IZdqF8yd/fnxc53N5uuWnv3Exsh30PjpjsCH
	apnq81812M7V2N1p2qKrxFKckWioxVxUnAgAVsj3HyEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tmbqbxWcEGWx9Km9xedccNgdGj8+b
	5AIYo9JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4CG
	KimUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslaINzY30jAz0TI30DI1jrQwNDIxMgWoS0jL2
	P17CXvDPquLTnz7GBsYdll2MnBxCAsoSvXvXs3UxcnBICJhILL1ZAxKWEBCTuHAPJMwFVDKf
	UeLMni9MIAkWAVWJH5PPsIHYbAK6EhNvXGEGsYUFZjBKbL1kCzJHREBd4ug+S5BeZoHVbBIb
	e1cyQ+ySk7i7bjuYzSsgKHFy5hMWiGWKEvO+fmSFiCtJ7L55kx0iLiexZOplJgibV2JG+1MW
	mPi0r2uYIWxpifOzNjDCHL34+2OoOL/Esds7mCD+4pV4cj8YZszuzV/YIGwBialnDkK1qknc
	WP8ayuaTWLPwLQvMmF2nljPD9DZs/A12GjPQyVO6H0LZBhJHFs1hRfcWr4CTxOGP/5knMMrN
	QpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjqFSfmFpfmpesl5+duYgQnp2cLdzB+OW99iFGA
	g1GJhzegc3qQEGtiWXFl7iFGCQ5mJRHeX0VAId6UxMqq1KL8+KLSnNTiQ4zJwAicyCwlmpwP
	TJx5JfGGxsYmZiamliYWBqbmpAkrifPevZkUJCSQnliSmp2aWpBaBLOFiYNTqoGRbYfj3853
	m233Gf9vP/Wi2u9aTPSBuOlmna9kY0sYg+TyKtbZ1u1aE/lkf87JVclGSx9ELpVe8y9LSXXB
	Af8vwlMZSmdon19w74XMrJvOUp02O4IP/LTQ6Er+VGEiuZzhyptMnSrB12Vn+J+6Oms2J7Rf
	3Xb+t0XO6cILD9PSeHf9fFe6X6ROiaU4I9FQi7moOBEA2K8DuZIDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAT4RiXr031167

Hi Dave,

I aplogize for wrong formatting of multiline comments.

> I really think this shouldn't be separated out in this way, because it
> means the decoder has to be implemented twice, and moving the checks far
> away from the code that the checks need to match.

I believe that you are right in this case, it requires decoder to be 
implemented twice. I will seperate the function and correct comments 
and send a new patch.

>Although this appears safe, I wonder whether it just creates additional
>ways for the code to be wrong, without providing much optimisation.

>(For example, the maximum number of registers that can be read is
>not actually TOTAL_REGISTERS.)

In this case I believe that for the instructions that can cause data abort 
are reading at max 13 registers (which is less than TOTAL_REGISTERS) currently 
this is what I was able to understand from the documentation I could find and t
he current code written.

So I believe that this condition will provide good optimization and will not create
additional ways for the code to go wrong

Regards
Anurag Aggarwal


------- Original Message -------
Sender : Dave Martin<Dave.Martin@arm.com>
Date : Nov 29, 2013 01:54 (GMT+05:30)
Title : Re: [PATCH] ARM : unwinder : Prevent data abort due to stack overflow in unwind_exec_insn Signed-off-by: Anurag Aggarwal 

On Thu, Nov 28, 2013 at 03:57:19PM +0530, Anurag Aggarwal wrote:
> While executing some unwind instructions stack overflow can cause a data abort
> when area beyond stack is not mapped to physical memory.
> 
> To prevent the data abort check whether it is possible to execute
> these instructions before unwinding the stack
> ---
>  arch/arm/kernel/unwind.c |   59 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 58 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> index 00df012..3777cd7 100644
> --- a/arch/arm/kernel/unwind.c
> +++ b/arch/arm/kernel/unwind.c
> @@ -49,6 +49,8 @@
>  #include 
>  #include 
>  
> +#define TOTAL_REGISTERS 16
> +
>  /* Dummy functions to avoid linker complaints */
>  void __aeabi_unwind_cpp_pr0(void)
>  {
> @@ -66,7 +68,7 @@ void __aeabi_unwind_cpp_pr2(void)
>  EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
>  
>  struct unwind_ctrl_block {
> - unsigned long vrs[16]; /* virtual register set */
> + unsigned long vrs[TOTAL_REGISTERS]; /* virtual register set */
>   const unsigned long *insn; /* pointer to the current instructions word */
>   int entries; /* number of entries left to interpret */
>   int byte; /* current byte number in the instructions word */
> @@ -235,6 +237,58 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
>   return ret;
>  }
>  
> +/* check whether there is enough space on stack to execute instructions
> +   that can cause a data abort*/

Nit: strange comment formatting in all your multi-line comments.

/*
* Please format multi-line comments
* like this.
*/

> +static int unwind_check_insn(struct unwind_ctrl_block *ctrl, unsigned long insn)
> +{

I really think this shouldn't be separated out in this way, because it
means the decoder has to be implemented twice, and moving the checks far
away from the code that the checks need to match.

Maybe you could refactor the code so that each insn has its own function,
including the check and the execution.

Then

> + unsigned long high, low;
> + int required_stack = 0;
> +
> + low = ctrl->vrs[SP];
> + high = ALIGN(low, THREAD_SIZE);
> +
> + /* check whether we have enough space to extract
> + atleast one set of registers*/
> + if ((high - low) > TOTAL_REGISTERS)
> + return URC_OK;

Although this appears safe, I wonder whether it just creates additional
ways for the code to be wrong, without providing much optimisation.

(For example, the maximum number of registers that can be read is
not actually TOTAL_REGISTERS.)

Cheers
---Dave

> +
> + if ((insn & 0xf0) == 0x80) {
> + unsigned long mask;
> + insn = (insn << 8) | unwind_get_byte(ctrl);
> + mask = insn & 0x0fff;
> + if (mask == 0) {
> + pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
> + insn);
> + return -URC_FAILURE;
> + }
> + while (mask) {
> + if (mask & 1)
> + required_stack++;
> + mask >>= 1;
> + }
> + } else if ((insn & 0xf0) == 0xa0) {
> + required_stack += insn & 7;
> + required_stack +=  (insn & 0x80) ? 1 : 0;
> + } else if (insn == 0xb1) {
> + unsigned long mask = unwind_get_byte(ctrl);
> + if (mask == 0 || mask & 0xf0) {
> + pr_warning("unwind: Spare encoding %04lx\n",
> + (insn << 8) | mask);
> + return -URC_FAILURE;
> + }
> + while (mask) {
> + if (mask & 1)
> + required_stack++;
> + mask >>= 1;
> + }
> + }
> +
> + if ((high - low) < required_stack)
> + return -URC_FAILURE;
> +
> + return URC_OK;
> +}
> +
>  /*
>   * Execute the current unwind instruction.
>   */
> @@ -244,6 +298,9 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
>  
>   pr_debug("%s: insn = %08lx\n", __func__, insn);
>  
> + if (unwind_check_insn(ctrl, insn) < 0)
> + return -URC_FAILURE;
> +
>   if ((insn & 0xc0) == 0x00)
>   ctrl->vrs[SP] += ((insn & 0x3f) << 2) + 4;
>   else if ((insn & 0xc0) == 0x40)
> -- 
> 1.7.0.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernelˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
