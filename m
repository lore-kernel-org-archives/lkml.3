Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab3CHAH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:07:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38611 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3CHAH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:07:57 -0500
Message-ID: <51392BD9.4010209@gmail.com>
Date: Thu, 07 Mar 2013 18:07:53 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: HOWTO Undo/Revert of_platform_populate?
References: <CAPybu_3LfWLYLSn52dgFDuBTASLvQ0_XWsywH=Avpma+4s921g@mail.gmail.com>
In-Reply-To: <CAPybu_3LfWLYLSn52dgFDuBTASLvQ0_XWsywH=Avpma+4s921g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 04:32 AM, Ricardo Ribalda Delgado wrote:
> Hi
> 
> I have an FPGA attached to the pci bus. The FPGA has an internal bus
> with multiple cores that are already supported in the kernel.
> 
> I have made a driver that populates those cores using a user provided
> device tree. I use the function of_platform_populate for that.
> 
> All this is working fine, but now I need a method to undo what
> of_platform_populate does when the fpga is reprogrammed.
> 
> I haven't found any function that does this in the api.
> 
> Before implementing my own I would like to know if am I missing something?

It's not possible in the current kernel. You need DT overlay support
that was posted recently.

Rob

