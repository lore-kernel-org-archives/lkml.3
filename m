Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbbADHR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:17:59 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:52942 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbADHR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:17:58 -0500
Message-ID: <54A8E91F.8090804@gmail.com>
Date: Sun, 04 Jan 2015 08:17:51 +0100
From: Ning Zhou <zhou.ning.gd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konrad Zapalowicz <bergo.torino@gmail.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        monamagarwal123@gmail.com, gulsah.1004@gmail.com,
        daniel.dy.ngu@gmail.com, dh.herrmann@gmail.com, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, teg@jklm.no, sjw0410@gmail.com,
        dilekuzulmez@gmail.com, davem@davemloft.net
Subject: Re: [PATCH] staging: gdm724x: fix coding style issues
References: <1420301035-29052-1-git-send-email-zhou.ning.gd@gmail.com> <20150104012713.GD25819@t400>
In-Reply-To: <20150104012713.GD25819@t400>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, then this one is abandoned. I will send two patches instead.

/Ning

On 2015-01-04 02:27, Konrad Zapalowicz wrote:
> On 01/03, Ning Zhou wrote:
>> Signed-off-by: Ning Zhou <zhou.ning.gd@gmail.com>
> 
> You need to describe your changes, a vague subject is not enough. Also
> keep in mind that one patch shall address one category of stuff and
> seems that yours could be separated into two.
> 
> thanks,
> konrad
> 
>> ---
>>  drivers/staging/gdm724x/gdm_lte.c | 3 ++-
>>  drivers/staging/gdm724x/gdm_mux.c | 2 +-
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
>> index 73eede1..7c4a77b 100644
>> --- a/drivers/staging/gdm724x/gdm_lte.c
>> +++ b/drivers/staging/gdm724x/gdm_lte.c
>> @@ -281,7 +281,8 @@ static int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
>>  		icmp6_out.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
>>  		icmp6_out.icmp6_code = 0;
>>  		icmp6_out.icmp6_cksum = 0;
>> -		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000); /* R=0, S=1, O=1 */
>> +		/* R=0, S=1, O=1 */
>> +		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000);
>>  
>>  		ns = (struct neighbour_solicitation *)
>>  			(skb_in->data + mac_header_len +
>> diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
>> index b5b063a..d1ab996 100644
>> --- a/drivers/staging/gdm724x/gdm_mux.c
>> +++ b/drivers/staging/gdm724x/gdm_mux.c
>> @@ -220,7 +220,7 @@ static int up_to_host(struct mux_rx *r)
>>  static void do_rx(struct work_struct *work)
>>  {
>>  	struct mux_dev *mux_dev =
>> -		container_of(work, struct mux_dev , work_rx.work);
>> +		container_of(work, struct mux_dev, work_rx.work);
>>  	struct mux_rx *r;
>>  	struct rx_cxt *rx = (struct rx_cxt *)&mux_dev->rx;
>>  	unsigned long flags;
>> -- 
>> 1.9.1
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
