Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3HUIqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:46:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab3HUIq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:46:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com, lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.20
References: <1377074477-31306-1-git-send-email-luis.henriques@canonical.com>
Date: Wed, 21 Aug 2013 09:46:26 +0100
In-Reply-To: <1377074477-31306-1-git-send-email-luis.henriques@canonical.com>
	(Luis Henriques's message of "Wed, 21 Aug 2013 09:41:16 +0100")
Message-ID: <87ob8r77od.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques <luis.henriques@canonical.com> writes:

> I am announcing the release of the Linux 3.5.7.20 kernel.
>
> The updated 3.5.y tree can be found at: 
>   git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
> and can be browsed at:
>   http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog
>
> The diff from v3.5.7.19 is posted as a follow-up to this email.
>
> The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
> For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
>
>  -Luis

This release fixes a regression introduced in the 3.5.7.19 kernel
after upstream commit backport:

 48bc130 iwlwifi: mvm: refuse connection to APs with BI < 16

Cheers,
-- 
Luis
