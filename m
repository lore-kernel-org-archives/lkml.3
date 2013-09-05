Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3IEN3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3IEN3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:29:39 -0400
Date: Thu, 5 Sep 2013 08:44:48 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, eparis@redhat.com, dan.duval@oracle.com,
        akpm@linux-foundation.org, rgb@redhat.com, oleg@redhat.com,
        chuck.anderson@oracle.com
Subject: Re: [PATCH 0/2] audit: fix soft lockup
Message-ID: <20130905084448.56e849ab@redhat.com>
In-Reply-To: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
References: <1378183735-19338-1-git-send-email-lcapitulino@redhat.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Sep 2013 00:48:53 -0400
Luiz Capitulino <lcapitulino@redhat.com> wrote:

> The second patch fixes a softlockup which is fully described and now is
> 100% reproducible with simple steps. The first patch fixes a bug I found
> while working on the second patch.

Can someone look at this series please? This is a very reproducible bug.
