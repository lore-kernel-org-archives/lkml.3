Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3AUEQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:16:06 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38514 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:16:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAGdaadbrcY5QdCtE35Hce7igST_JP82_iPeLRR39Tx5TafB4XA@mail.gmail.com>
References: <CAGdaadbrcY5QdCtE35Hce7igST_JP82_iPeLRR39Tx5TafB4XA@mail.gmail.com>
From: Mulyadi Santosa <mulyadi.santosa@gmail.com>
Date: Mon, 21 Jan 2013 11:15:22 +0700
Message-ID: <CAGdaadZXLpkrdvrBNoAEFu+P0p+6wLMA2uPgZVB6idVBBLHaEg@mail.gmail.com>
Subject: Re: [RFC] kernel config template for running inside virtual machine
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:03 AM, Mulyadi Santosa
<mulyadi.santosa@gmail.com> wrote:
> Hello everybody
>
> With the significant usage of virtualization in recent years, I
> personally think there might be a need to easily generate somewhat
> more optimal kernel for running as VM guest.

To make it clearer, it will be saved under arch/x86/configs using name
like vm_defconfig or alike.

PS: I am not subscribed to linux-kernel@vger right now, so kindly cc:
with in your reply.


-- 
regards,

Mulyadi Santosa
Freelance Linux trainer and consultant

blog: the-hydra.blogspot.com
training: mulyaditraining.blogspot.com
