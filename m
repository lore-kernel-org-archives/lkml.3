Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3JBG4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:56:37 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:41353 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3JBG4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAPUj1OOQf347e1Ou1FKoivHAcMdrW9SjrrwBooGd0spyjepWtA@mail.gmail.com>
References: <CAPUj1OOQf347e1Ou1FKoivHAcMdrW9SjrrwBooGd0spyjepWtA@mail.gmail.com>
Date: Wed, 2 Oct 2013 12:26:34 +0530
Message-ID: <CAPUj1OMpVU4n1Grm3H-mMwL_A1GsNDLb98PQv7VQp0zer-AhMg@mail.gmail.com>
Subject: Re: AMP linux and GPU/HDMI controller sharing
From: Mj Embd <mj.embd@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

Please help me out. No comments so far ...

On 9/29/13, Mj Embd <mj.embd@gmail.com> wrote:
> Hi,
>
> I have got a client request to support on their board 2 instances of
> linux(Ubuntu) running as an AMP.
> The board has 2 ARM cores and a GPU. The LED monitor which connects to
> the board is using HDMI.
>
> Two cores can communicate via a IPI handshake.
> So release and acquire of the GPU can be done cooperatively.
>
> My problem is that, I have done partitioning of other resources but
> not sure how to share the GPU. What I have to do is save the buffers
> associated with current GPU owner in memory and restore later. I dont
> know much about GPU programming and am looking for pointers /any help
> which is possible.
>
> Also the solution I have to create has to be GPU agnostic.
>
> Please help me out.
>


-- 
-mj
