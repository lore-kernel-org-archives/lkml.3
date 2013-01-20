Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3ATLUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:20:12 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53553 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3ATLUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:20:11 -0500
MIME-Version: 1.0
Date: Sun, 20 Jan 2013 11:20:09 +0000
Message-ID: <CAAMvbhGM+s0LKJVqR8GWz4LkBhSZCCT_xa2qh=dFjV8A92jqOg@mail.gmail.com>
Subject: Comparing linux kernel trees.
From: James Courtier-Dutton <james.dutton@gmail.com>
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been given a linux kernel sources tar file.
It contains a modified version of the linux kernel.
It is just source files, without any "git" history.
What I would like to do is compare this with the mainline linux kernel
git tree, and find the tag from the kernel git tree that this source
code is most similar to.
E.g. Finding the source code is really kernel 3.2.1 with some minor changes.
My plan at the moment is just to automate a checkout of every git tag,
then run diff -ur on it, and then choose the smallest diff file
output.
But, has anyone got a better method?

Kind Regards

James
