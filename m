Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaKFTtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:49:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:35172 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339AbaKFTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:49:32 -0500
Date: Thu, 6 Nov 2014 14:49:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vojtech Pavlik <vojtech@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        live-patching@vger.kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel Live Patching
Message-ID: <20141106144926.01441bdc@gandalf.local.home>
In-Reply-To: <20141106193433.GA16347@treble.redhat.com>
References: <1415284748-14648-1-git-send-email-sjenning@redhat.com>
	<20141106184446.GA12779@infradead.org>
	<20141106185157.GB29272@suse.cz>
	<20141106185857.GA7106@infradead.org>
	<20141106193433.GA16347@treble.redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2014 13:34:33 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Thu, Nov 06, 2014 at 10:58:57AM -0800, Christoph Hellwig wrote:
> > On Thu, Nov 06, 2014 at 07:51:57PM +0100, Vojtech Pavlik wrote:
> > > I don't think this specific example was generated. 
> 
> So there are two ways to use this live patching API: using a generated
> module (e.g., using the kpatch-build tool) or manually compiling a
> module via kbuild.
> 
> Vojtech's right, the provided example was not generated.  Maybe it
> belongs in samples/livepatch?
> 

I understand that there is two methods in doing this. Is it possible to
create a "simple generator" that only does the simple case. Perhaps can
detect non simple cases where it rejects the change and tells the user
they need to reboot.

Something that isn't really related to either kpatch or kGraft, but can
be used for testing purposes?

-- Steve
