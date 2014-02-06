Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaBFMZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:25:36 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63217 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756345AbaBFMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:25:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Thu, 06 Feb 2014 13:40:04 +0100
Message-ID: <2240387.gpLEHJv4c1@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52F33BE7.2040607@gmail.com>
References: <52F2CC7B.80406@gmail.com> <52F33BE7.2040607@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 08:38:15 AM Francis Moreau wrote:
> Hi,
> 
> On 02/06/2014 12:42 AM, Bastien Traverse wrote:
> > Hello,
> > 
> > I'm encountering the exact same problem (same model of machine, same
> > controller, same OS) and was wondering where this bug was at.
> 
> I'm still leaving with this issue since my initial posting unfortunately :(
> 
> I'm wondering why PM support on this machine is so crapish (it initialy
> oopsed when resuming due to a bug in rtsx driver).

Is this a new problem in 3.12?

Rafael

