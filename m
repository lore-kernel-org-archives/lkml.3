Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574Ab3GSFuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:50:16 -0400
Received: from mel.act-europe.fr ([194.98.77.210]:58143 "EHLO
	smtp.eu.adacore.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330Ab3GSFuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:50:13 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 01:50:13 EDT
Subject: Re: [RFC / musing] Scoped exception handling in Linux userspace?
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
From: Tristan Gingold <gingold@adacore.com>
In-Reply-To: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
Date: Fri, 19 Jul 2013 07:43:40 +0200
Cc: linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Content-Transfer-Encoding: 7bit
Message-Id: <0513AB0D-9821-4817-BAF6-5378E5BCD0C0@adacore.com>
References: <CALCETrVioVM=pdCU3WhU6qDtGQyqML=btBRZ5+aV6bASj9GkOQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19, 2013, at 2:26 AM, Andy Lutomirski wrote:

> Windows has a feature that I've wanted on Linux forever: stack-based
> (i.e. scoped) exception handling.  The upshot is that you can do,
> roughly, this (pseudocode):

[...]

Indeed Windows and OpenVMS have such a mechanism. That's clean and
library friendly, but please read:
https://www.usenix.org/conference/wiess-2000/c-exception-handling-ia64
to understand how it hurts optimization.

(And no, raising an exception from an handler doesn't always work,
 due to optimizations allowed by the gcc exception mechanism).

Regards,
Tristan.

