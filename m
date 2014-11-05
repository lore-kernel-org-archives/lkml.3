Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaKEAUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 19:20:13 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49077 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaKEAUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 19:20:11 -0500
Date: Tue, 4 Nov 2014 16:20:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Norbert Preining <preining@logic.at>
cc: linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
In-Reply-To: <20141105001243.GR13232@auth.logic.tuwien.ac.at>
Message-ID: <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at> <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com> <20141105001026.GQ13232@auth.logic.tuwien.ac.at> <20141105001243.GR13232@auth.logic.tuwien.ac.at>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Norbert Preining wrote:

> Hi David,
> 
> one more thing, attached dmesg output with some page faults,
> maybe this is connected?
> 

Hmm, I'm not aware of any mm->mmap_sem starvation issues in 3.18-rc, maybe 
this is a duplicate of another issue that someone has reported that I 
haven't seen.  The lengthy output of echo t > /proc/sysrq-trigger should 
give a clue as to what is holding it or perhaps this is a more generic 
rwsem issue.
