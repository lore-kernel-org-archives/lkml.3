Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbaLKOkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:40:04 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:33624 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaLKOkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:40:02 -0500
Message-ID: <5489ACBE.1050006@cogentembedded.com>
Date: Thu, 11 Dec 2014 17:39:58 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>, nicolas.ferre@atmel.com,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, soren.brinkmann@xilinx.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net/macb: fix compilation warning for print_hex_dump()
 called with skb->mac_header
References: <efa28485b430e77f5254248cb396da431d03fc5b.1418292741.git.cyrille.pitchen@atmel.com>
In-Reply-To: <efa28485b430e77f5254248cb396da431d03fc5b.1418292741.git.cyrille.pitchen@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/11/2014 1:15 PM, Cyrille Pitchen wrote:

    Citing the warning here would be a good idea.

> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

WBR, Sergei

