Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3ATNfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 08:35:07 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:38995 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3ATNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 08:35:05 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2013 08:35:05 EST
Message-ID: <50FBF0D7.703@ladisch.de>
Date: Sun, 20 Jan 2013 14:27:51 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: James Courtier-Dutton <james.dutton@gmail.com>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Comparing linux kernel trees.
References: <CAAMvbhGM+s0LKJVqR8GWz4LkBhSZCCT_xa2qh=dFjV8A92jqOg@mail.gmail.com>
In-Reply-To: <CAAMvbhGM+s0LKJVqR8GWz4LkBhSZCCT_xa2qh=dFjV8A92jqOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Courtier-Dutton wrote:
> I have been given a linux kernel sources tar file.
> It contains a modified version of the linux kernel.
> It is just source files, without any "git" history.
> What I would like to do is compare this with the mainline linux kernel
> git tree, and find the tag from the kernel git tree that this source
> code is most similar to.

The kernel *knows* which version it is.

> My plan at the moment is just to automate a checkout of every git tag,
> then run diff -ur on it, and then choose the smallest diff file
> output.
> But, has anyone got a better method?

head -5 Makefile


Regards,
Clemens
