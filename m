Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaKGKSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:18:23 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33543 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaKGKSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:18:20 -0500
Date: Fri, 7 Nov 2014 02:18:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Aristeu Rozanski <aris@redhat.com>, Dave Hansen <dave@sr71.net>,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>,
        Eric Paris <eparis@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Jesse Gross <jesse@nicira.com>, Jonathan Corbet <corbet@lwn.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] lib/flex_array: make build optional
In-Reply-To: <20141107033102.GB7249@thin>
Message-ID: <alpine.DEB.2.10.1411070217280.32405@chino.kir.corp.google.com>
References: <1415309241-12971-1-git-send-email-aris@redhat.com> <545BE927.9060208@sr71.net> <545BEBD6.4030803@sr71.net> <20141106215056.GK26472@redhat.com> <20141107033102.GB7249@thin>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014, Josh Triplett wrote:

> https://git.kernel.org/cgit/linux/kernel/git/josh/linux.git/commit/?h=tiny/unflex-array&id=6631d5fb4cf395ebd2dc0f2da05525b9d3436a3f
> 
> Already done.
> 

Thanks Josh, and the "unflex array" patch title is great.

Acked-by: David Rientjes <rientjes@google.com>
