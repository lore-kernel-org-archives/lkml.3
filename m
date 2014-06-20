Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaFTOYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:24:40 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:38696 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbaFTOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:24:39 -0400
Date: Fri, 20 Jun 2014 09:24:36 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: kernel BUG at /src/linux-dev/mm/mempolicy.c:1738! on v3.16-rc1
In-Reply-To: <20140619215641.GA9792@nhori.bos.redhat.com>
Message-ID: <alpine.DEB.2.11.1406200923220.10271@gentwo.org>
References: <20140619215641.GA9792@nhori.bos.redhat.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, Naoya Horiguchi wrote:

> I'm suspecting that mbind_range() do something wrong around vma handling,
> but I don't have enough luck yet. Anyone has an idea?

Well memory policy data corrupted. This looks like you were trying to do
page migration via mbind()? Could we get some more details as to what is
going on here? Specifically the parameters passed to mbind would be
interesting.

