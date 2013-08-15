Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab3HOAPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 20:15:03 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38296 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3HOAPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 20:15:01 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Aug 2013 17:14:40 -0700
Message-ID: <CALCETrXmy1KwGUNbG0pgsbAt=mk27P3xd0ja4i9sPB6RhbcOeg@mail.gmail.com>
Subject: mei oopses at startup if it's built-in (3.11-rc5)
To: Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It blows up early enough that it's awkward to get the whole oops, but
it's in the probe function.  If it's a module, I get instead:

[   73.401679] mei_me 0000:00:16.0: Device doesn't have valid ME Interface
[   73.401684] mei_me 0000:00:16.0: initialization failed.

Let me know if I should debug further, but this may be obvious.

--Andy
