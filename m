Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab3CCKky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 05:40:54 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49323 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369Ab3CCKkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 05:40:53 -0500
Message-ID: <1362307248.1334.32.camel@x61.thuisdomein>
Subject: Re: [PATCH 13/14] scripts: add checkmaintainers.py
From: Paul Bolle <pebolle@tiscali.nl>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>
Date: Sun, 03 Mar 2013 11:40:48 +0100
In-Reply-To: <1362275632-20242-14-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
	 <1362275632-20242-14-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Mar 2013 10:40:49.0040 (UTC) FILETIME=[91C8A900:01CE17FB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-02 at 22:53 -0300, Cesar Eduardo Barros wrote:
> For every file pattern, it checks if the pattern matches any file or
> directory in the kernel tree, printing the patterns which do not have a
> match.

In a script I cobbled together for local consumption, I invoked "git
ls-files" to generate the list of files to check against. Using the
files and directories currently in one's kernel tree is liable to
generating false positives or false negatives.


Paul Bolle

