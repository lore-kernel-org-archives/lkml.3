Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbaBJBYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:24:19 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33372 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJBYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:24:17 -0500
MIME-Version: 1.0
In-Reply-To: <1391994986.18779.169.camel@triegel.csb>
References: <52F3DA85.1060209@arm.com>
	<20140206185910.GE27276@mudshark.cambridge.arm.com>
	<20140206192743.GH4250@linux.vnet.ibm.com>
	<1391721423.23421.3898.camel@triegel.csb>
	<20140206221117.GJ4250@linux.vnet.ibm.com>
	<1391730288.23421.4102.camel@triegel.csb>
	<20140207042051.GL4250@linux.vnet.ibm.com>
	<20140207074405.GM5002@laptop.programming.kicks-ass.net>
	<20140207165028.GO4250@linux.vnet.ibm.com>
	<20140207165548.GR5976@mudshark.cambridge.arm.com>
	<20140207180216.GP4250@linux.vnet.ibm.com>
	<1391992071.18779.99.camel@triegel.csb>
	<CA+55aFwFVr2KiXX2MObMBGypQk9eabe-93Nhmro=HL1RtC-1jw@mail.gmail.com>
	<1391994986.18779.169.camel@triegel.csb>
Date: Sun, 9 Feb 2014 17:24:14 -0800
X-Google-Sender-Auth: lCK0TBYZGQRfld2L5Hpepwx608I
Message-ID: <CA+55aFy0SPge-z9TbaLF2yxLffVTviv_WhhbkXsB5mMA9d9iaQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 5:16 PM, Torvald Riegel <triegel@redhat.com> wrote:
>
> (a) seems to say that you don't like requiring programmers to mark
> atomic accesses specially.  Is that the case?

In Paul's example, they were marked specially.

And you seemed to argue that Paul's example could possibly return
anything but 0/0.

If you really think that, I hope to God that you have nothing to do
with the C standard or any actual compiler I ever use.

Because such a standard or compiler would be shit. It's sadly not too uncommon.

             Linus
