Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3GPTi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:38:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48117 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991Ab3GPTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:38:28 -0400
Date: Tue, 16 Jul 2013 20:38:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a
 user namespace
Message-ID: <20130716193826.GP4165@ZenIV.linux.org.uk>
References: <20130716192920.GA8980@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716192920.GA8980@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 02:29:20PM -0500, Serge Hallyn wrote:
> All the files will be owned by host root, so there's no security
> concern in allowing this.

Files owned by root != very bad things can't be done by non-root.
Especially for debugfs, which is very much a "don't even think about
mounting that on a production box" thing...
