Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBIQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 11:25:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:60378 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaBIQZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 11:25:55 -0500
MIME-Version: 1.0
Date: Sun, 9 Feb 2014 11:25:53 -0500
Message-ID: <CAHqbYQv-naifPii=DtRotwcX18bzuGr76BTOddxdBU78jC4sAw@mail.gmail.com>
Subject: kvm mmu notifier
From: Hu Yaohui <loki2441@gmail.com>
To: kvm <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
If the host system decides that it wants to push a given page out to
swap, the host will notify the host through registered mmu notifier to
inform the guest. I am wondering if there any other situations, other
than swapping, which will trigger the mmu notifier to inform host page
change to the guest?
Thanks for your time!

Best Wishes,
Yaohui Hu
