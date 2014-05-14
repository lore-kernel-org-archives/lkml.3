Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaENFCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:02:19 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:43085 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaENFCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:02:17 -0400
Date: Wed, 14 May 2014 07:02:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/34] kbuild: Introduce KCONFIG_AUTOCONFIGDEP variable
 for conf tool
Message-ID: <20140514050203.GB13791@ravnborg.org>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
 <1400018609-20486-3-git-send-email-alexis.berlemont@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400018609-20486-3-git-send-email-alexis.berlemont@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:02:57AM +0200, Alexis Berlemont wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> Introducing KCONFIG_AUTOCONFIGDEP variable for conf tool
> allowing to specify custom auto.conf.cmd file.

The change looks good at it complments what we already have of overrides.
But please document this in Documentation/kbuild/...

	Sam
