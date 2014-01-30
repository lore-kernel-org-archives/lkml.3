Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaA3LCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 06:02:55 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54199 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaA3LCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 06:02:54 -0500
Message-ID: <1391079767.2680.18.camel@snow.station>
Subject: Re: same ext4 file system corruption on different machines
From: Luca Ognibene <luca.ognibene@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Date: Thu, 30 Jan 2014 12:02:47 +0100
In-Reply-To: <20140129173826.GA30419@thunk.org>
References: <1390999955.2601.22.camel@snow.station>
	 <1391000743.2601.26.camel@snow.station> <20140129173826.GA30419@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno mer, 29/01/2014 alle 12.38 -0500, Theodore Ts'o ha scritto:
> On Wed, Jan 29, 2014 at 02:05:43PM +0100, Luca Ognibene wrote:
> > I say "same ext4 file system corruption" because e2fsck reports errors
> > on inodes around 127233 on all file systems.a I'm not sure about the
> > syslog errors because i have syslog logs for only the latest faulty
> > partition.
> 

Sorry i made a mistake in the first email. These dom drives are IDE, not
SATA.

ciao
Luca

