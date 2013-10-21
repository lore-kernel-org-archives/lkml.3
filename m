Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3JUXK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:10:26 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34121 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JUXKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:10:25 -0400
X-Originating-IP: 77.221.165.98
Date: Tue, 22 Oct 2013 00:10:17 +0100
From: Josh Triplett <josh@kernel.org>
To: tech-board-discuss@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org
Subject: Standing for the Technical Advisory Board
Message-ID: <20131021231017.GD3953@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm standing for election to the Linux Foundation Technical Advisory
Board.  I plan to attend the Wednesday-evening event that will host the
TAB election.


I work in many different areas of the Linux and Open Source community,
at all levels of the stack, including the kernel, plumbing,
applications, services, distributions, and packaging.

My first Open Source contribution, accepted ten years ago this month,
was to OpenOffice.org, to the cross-distribution ooo-build patchset that
later became LibreOffice, to make it build without the then-proprietary
Java so it could enter Debian main:
https://lists.debian.org/debian-devel-changes/2003/10/msg02847.html
Not long after that, I started contributing to XCB, and in the process
of helping to replace Xlib I became a de-facto co-maintainer of Xlib
through the "last sucker to touch it" rule, thus showing a pattern of
stepping up to address long-standing problems, and/or demonstrating the
requisite degree of insanity.

I maintained the Sparse static analysis tool for several years, making
me one of two people to take over maintainership of a project from
Linus.  I'm one of the (thankfully growing) handful of people in the
world to understand how RCU works, and I have the dissertation to prove
it.  (I think it says a lot about RCU that attempting to make it more
approachable resulted in a three-sentence set of usage guidelines and a
hundred pages of supporting material.)  I currently maintain the
rcutorture test module and the ACPI BGRT driver.

I've also made many community contributions that don't directly involve
writing code.  I'm one of the most prolific patch reviewers in the
kernel, going by Reviewed-by tags.  I've written significant parts of
Documentation/CodingStyle, documenting previously unwritten bits of
kernel-community tribal knowledge that many developers would mention in
patch NAKs but none could find a reference for.  And I've provided
mentorship for various projects by students or interns to contribute to
the Linux kernel and the X Window System, including student "capstone"
projects, Google Summer of Code interns, and Outreach Program for Women
interns.

I currently work as Intel's ChromeOS architect.  Contributing across an
entire Linux distribution, and to an Open Source commercial product
based on Linux, provides a view not just into how things fit together
but how they often don't.  I've had first-hand experience with the
tension between shipping a product and creating the right technical
solution, as well as what happens when the kernel or low-level userspace
breaks assumptions made higher up the stack.

I enjoy working with many different parts of a system to produce a
satisfying result that's more cohesive than any one project or patch can
achieve alone; I'm standing for the TAB as a natural extension of that
approach.


In the spirit of Rusty Russell's perennial talk slide on "better things
you could be learning about rather than attending this talk", other
people standing for election that I plan to vote for and would encourage
others to vote for as well:

Jonathan Corbet: I can't think of a better representative for the
community than the editor-in-chief of LWN.

Sarah Sharp: Sarah maintains a a major Linux subsystem, represents the
needs of Linux and Open Source to industry and standards groups, and
works tirelessly to help new developers join the kernel community.

Matthew Garrett: Matthew has extensive experience making hardware,
firmware, and software play nice with each other, as well as experience
working with people and organizations to make that possible and help
keep it that way.

Greg Kroah-Hartman: Greg maintains critical pieces of core kernel
infrastructure, acts as a stalwart front-line defender of kernel
standards and quality, and helps many prospective driver authors learn
the give-and-take required to successfully participate in the community.


- Josh Triplett
