Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3HOJBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:01:12 -0400
Received: from jenson.atom.hu ([62.112.193.66]:56733 "EHLO jenson.atom.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab3HOJBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:01:09 -0400
From: Gergely Risko <gergely@risko.hu>
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: memcontrol: fix handling of swapaccount parameter
References: <1376486495-21457-1-git-send-email-gergely@risko.hu>
	<20130814183604.GE24033@dhcp22.suse.cz>
	<20130814184956.GF24033@dhcp22.suse.cz>
	<87ioz855o0.fsf@gergely.risko.hu>
	<20130815074714.GA27864@dhcp22.suse.cz>
Date: Thu, 15 Aug 2013 11:01:01 +0200
In-Reply-To: <20130815074714.GA27864@dhcp22.suse.cz> (Michal Hocko's message
	of "Thu, 15 Aug 2013 09:47:14 +0200")
Message-ID: <87eh9v5nw2.fsf@gergely.risko.hu>
User-Agent: GNU Emacs with Gnus
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 09:47:14 +0200, Michal Hocko <mhocko@suse.cz> writes:

> Ohh, I have totally missed those left-overs. I would rather fix the doc
> than reintroduce the handling without any value.

Okay, fine with me, thanks for fixing these left-overs!

Gergely
