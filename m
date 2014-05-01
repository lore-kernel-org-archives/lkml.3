Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaEAWU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 18:20:26 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:60436 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaEAWUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 18:20:21 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 15:20:00 -0700
Message-ID: <CALCETrUXbS4BMWMd0XXgFqyvmpu+WML840_mzbPiov8WmaA=Xw@mail.gmail.com>
Subject: Connecting to sockets on MNT_READONLY mounts?
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it supposed to work?  It does, but this seems odd.  If the current
behavior is intentional, then I'll submit a patch to add a new mount
flag to turn off ipc.  If it's not, then I'll submit a patch to fix
it.

-- 
Andy Lutomirski
AMA Capital Management, LLC
