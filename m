Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762022Ab3JQBU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:20:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760694Ab3JQBU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:20:57 -0400
Date: Thu, 17 Oct 2013 02:20:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jim Lieb <jlieb@panasas.com>, tytso@mit.edu, viro@zeniv.linux.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH 1/3] switch_creds:  Syscall to switch creds for file
 server ops
Message-ID: <20131017012050.GR13318@ZenIV.linux.org.uk>
References: <1381960919-4542-1-git-send-email-jlieb@panasas.com>
 <1381960919-4542-2-git-send-email-jlieb@panasas.com>
 <20131016224248.GQ13318@ZenIV.linux.org.uk>
 <87ppr4lmp3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppr4lmp3.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 06:18:16PM -0700, Eric W. Biederman wrote:

> That doesn't look bad but it does need capable(CAP_SETUID) &&
> capable(CAP_SETGID) or possibly something a little more refined.

D'oh

> I don't think we want file descriptor passing to all of a sudden become
> a grant of privilege, beyond what the passed fd can do.

Definitely.  And an extra ) to make it compile wouldn't hurt either...
