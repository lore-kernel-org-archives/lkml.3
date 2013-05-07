Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3EGXyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:54:17 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36718 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756468Ab3EGXyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:54:14 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 7 May 2013 16:53:52 -0700
X-Google-Sender-Auth: 2NYlf9mx3cJLDDgmvn3HNpjj4SU
Message-ID: <CAB=NE6Wy0dp51wDxKzo74Kz=2F-MQjOnARS1r-z3v+LrOwhn-Q@mail.gmail.com>
Subject: Dropping non supported kernels for kernel backports ?
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today the backports project provides support to backport down to
2.6.24 for some subsystems. While this is good for users in practice
for development and maintenance this is quite a bit of overhead. Apart
from older kernels there are also gaps in between stable releases that
are not supported. For example 3.8 and 3.4 are supported but anything
in between is not (3.5, 3.6, 3.7), but we still do support them on the
backports project. At times this may mean a stable fix may get
propagated onto a the linux-3.4.y branch but obviously not the the
linux-3.5.y branch. If backporting expressing this becomes a bit
complex and we have dealt with it. In short, its a pain.

I'd like to see what folks thought if we went ahead and *only*
supported kernels listed on kernel.org as supported. This would help
with the Linux kernel maintainer effort by also persuading users to
upgrade to stable releases as well as educating around this.

If v3.10 backported releases are too soon to do this I propose we
seriously consider it for v3.11 releases. Any thoughts?

  Luis
