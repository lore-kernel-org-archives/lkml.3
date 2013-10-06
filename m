Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab3JFVsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:48:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48496 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3JFVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:48:36 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 14:48:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Preferred line-break style around binary operators?
Message-ID: <20131006214829.GA20112@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two common approaches to breaking long lines at binary
operators: breaking the line before the operator (putting the operator
at the start of the next line), or breaking the line after the operator
(putting the operator at the end of the previous line).

CodingStyle doesn't define any requirement here, and the kernel uses
both approaches; for instance, using && as a sample:

$ git grep -h '&&$' | wc -l
28872
$ git grep -h '^[[:space:]]*&&' | wc -l
4169

Which style should kernel code use?  I can submit a CodingStyle patch
documenting that preference for future reference.

- Josh Triplett
