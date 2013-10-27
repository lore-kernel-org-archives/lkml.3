Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3J0Td6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:33:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42106 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3J0Td4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:33:56 -0400
Date: Sun, 27 Oct 2013 12:33:52 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] vxlan: silence one build warning
Message-ID: <20131027123352.3d49d75b@nehalam.linuxnetplumber.net>
In-Reply-To: <CAEH94LjOnWgchhV__TLK9se-Cb3WkGnVfNZgNBBLdZL0kNM=-g@mail.gmail.com>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
	<20131025084134.6cfa153a@samsung-9>
	<CAEH94Lia4VVU6Vnn_7DhOHo4yhR-tsMPu7biMCeSMgQPvkQrug@mail.gmail.com>
	<20131026074819.6a5f4e24@samsung-9>
	<CAEH94LjOnWgchhV__TLK9se-Cb3WkGnVfNZgNBBLdZL0kNM=-g@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Oct 2013 10:30:56 +0800
Zhi Yong Wu <zwu.kernel@gmail.com> wrote:

> HI, Stephen
> 
> I saw it on Fedora 17 without latest kernel. Then what do you think
> that it is appropriate to solve this problem? discard this patch? If
> yes, i can also agree.
> 

Either find where the uninitialized use is being caused by finding the code
path where it happens (manual analysis), or ignore the warning.


