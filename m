Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964860AbaEQQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:51:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774AbaEQQv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:51:26 -0400
Date: Sat, 17 May 2014 18:51:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        linux-kbuild@vger.kernel.org, mmarek@suse.cz
Subject: Re: [PATCH 8/8] Kbuild: add inline-account tool to find inline
 bloat
Message-ID: <20140517165123.GK1873@two.firstfloor.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-9-git-send-email-andi@firstfloor.org>
 <20140517083144.GA16691@ravnborg.org>
 <20140517093615.GA16926@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517093615.GA16926@ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Patched the calls to nm and objdump - but it gave no output
> when I ran the script.

You have to compile with debug info on.

-Andi
