Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3HWDxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 23:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3HWDxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 23:53:54 -0400
Date: Thu, 22 Aug 2013 23:53:44 -0400
From: Dave Jones <davej@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: unused swap offset / bad page map.
Message-ID: <20130823035344.GB5098@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hillf Danton <dhillf@gmail.com>, Linux-MM <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130807055157.GA32278@redhat.com>
 <CAJd=RBCJv7=Qj6dPW2Ha=nq6JctnK3r7wYCAZTm=REVOZUNowg@mail.gmail.com>
 <20130807153030.GA25515@redhat.com>
 <CAJd=RBCyZU8PR7mbFUdKsWq3OH+5HccEWKMEH5u7GNHNy3esWg@mail.gmail.com>
 <20130819231836.GD14369@redhat.com>
 <CAJd=RBA-UZmSTxNX63Vni+UPZBHwP4tvzE_qp1ZaHBqcNG7Fcw@mail.gmail.com>
 <20130821204901.GA19802@redhat.com>
 <CAJd=RBBNCf5_V-nHjK0gOqS4OLMszgB7Rg_WMf4DvL-De+ZdHA@mail.gmail.com>
 <20130823032127.GA5098@redhat.com>
 <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBArkh3sKVoOJUZBLngXtJubjx4-a3G6s7Tn0N=Pr1gU4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 11:27:29AM +0800, Hillf Danton wrote:
 > On Fri, Aug 23, 2013 at 11:21 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I still see the swap_free messages with this applied.
 > >
 > Decremented?

It actually seems worse, seems I can trigger it even easier now, as if
there's a leak.

	Dave

