Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3EFUAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:00:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37164 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab3EFUAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:00:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130506190611.GE3501@linux.vnet.ibm.com>
References: <CAE9FiQUTV_e9De-6zCPs6OQrVAUJV2VLZDBmxFpJtnjNO3rKfw@mail.gmail.com>
	<20130506190611.GE3501@linux.vnet.ibm.com>
Date: Mon, 6 May 2013 13:00:08 -0700
X-Google-Sender-Auth: sFcSAByKnjQwv6uRmjo7QFPMpkU
Message-ID: <CAE9FiQXgmFbybdK6mXUrh=zQw6kPbxLh0qGWKMGGVy+jhDZYSA@mail.gmail.com>
Subject: Re: RCU init call bootmem allocation after slub us ready.
From: Yinghai Lu <yinghai@kernel.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 12:06 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:

> Do you have commit fa0f93cd6a (rcu: Don't allocate bootmem from rcu_init())?
> If not, could you please try applying it?

oh, must be in tip/rcu branch...

i only test tip/x86 for a while.

sorry for the noise.

Yinghai
