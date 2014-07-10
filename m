Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaGJAH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:07:28 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40368 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaGJAH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:07:27 -0400
Date: Thu, 10 Jul 2014 02:07:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 5/9] perf, tools: Add perf download to download event
 files v4
Message-ID: <20140710000725.GR18735@two.firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
 <1403910964-11017-6-git-send-email-andi@firstfloor.org>
 <20140709222027.GK20938@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140709222027.GK20938@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess the other alternative is curl.. could u check for this one as well?

I looked at this earlier, but it made a complete mess of the download
script to handle both. So right now I stayed with wget only.

-Andi
