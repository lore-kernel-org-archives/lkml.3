Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbbAGIbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:31:42 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:52647 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbAGIbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:31:40 -0500
Message-ID: <54ACEE83.10105@synopsys.com>
Date: Wed, 7 Jan 2015 13:59:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: stable 3.14 backport request for ARC
References: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BC9324@IN01WEMBXA.internal.synopsys.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tuesday 23 December 2014 01:38 PM, Vineet Gupta wrote:
> Hi,
> 
> Can you please backport the following mainline commits to 3.14 stable.
> 
> 2014-02-07 ec7ac6afd07b ARC: switch to generic ENTRY/END assembler annotations 
> 2014-04-18 64ee9f32c33c ARC: Delete stale barrier.h 
> 
> 
> Thx,
> -Vineet

It seems above request fell thru the cracks due to holiday season.
Can you please queue up above for next 3.14 stable cycle.

and also the following:

2014-06-24 ba25915fb2cd ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND
2014-10-01 e8ef060b37c2 ARC: [nsimosci] move peripherals to match model to FPGA

Thx,
-Vineet
