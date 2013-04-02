Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab3DBUBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761104Ab3DBUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:01:45 -0400
Date: Tue, 2 Apr 2013 16:00:27 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: ipc,sem: sysv semaphore scalability
Message-ID: <20130402200027.GE17422@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Davidlohr Bueso <davidlohr.bueso@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
	Michel Lespinasse <walken@google.com>,
	Larry Woodman <lwoodman@redhat.com>,
	"Vinod, Chegu" <chegu_vinod@hp.com>,
	Stanislav Kinsbursky <skinsbursky@parallels.com>
References: <20130326192852.GA25899@redhat.com>
 <20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
 <20130329161746.GA8391@redhat.com>
 <CA+55aFwA6CpODkJwHFd59EbNxOrP-FHM+xG8Xcgeni2DBotGPA@mail.gmail.com>
 <20130329190642.GC23893@redhat.com>
 <CA+55aFyj2zfumVUJ7JMhJkQY_LiyQYX+tK4Cu4Jg=g72-amC2g@mail.gmail.com>
 <1364585774.31320.9.camel@thor.lan>
 <515B026B.1040901@oracle.com>
 <CA+55aFz-0J3uhJC-00AJ0R-4TVOYqFGJk0h5x0HmaX+JR6_MYQ@mail.gmail.com>
 <515B371D.9010809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515B371D.9010809@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:53:01PM -0400, Sasha Levin wrote:
 > On 04/02/2013 01:52 PM, Linus Torvalds wrote:
 > > On Tue, Apr 2, 2013 at 9:08 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
 > >>
 > >> By just playing with the 'msgsz' parameter with MSG_COPY set.
 > > 
 > > Hmm. Looking closer, I suspect you're testing without commit
 > > 88b9e456b164 ("ipc: don't allocate a copy larger than max"). That
 > > should limit the size passed in to prepare_copy -> load_copy to
 > > msg_ctlmax.
 > 
 > That commit has a revert in the -next trees, do we need a revert
 > of the revert?

Yeah, I told Andrew to drop that, but I think he's travelling.

	Dave

