Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3IZMeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:34:24 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:33836 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745Ab3IZMeX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:34:23 -0400
MIME-Version: 1.0
Date: Thu, 26 Sep 2013 09:34:22 -0300
Message-ID: <CAGG-pUTDbZzWv9qyQdZ4JELZT59=BL4EA64rPCrUA+8jNX=WzQ@mail.gmail.com>
Subject: [RFC] NULL pointer checking?
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to know when to do the NULL pointer checking.

Calling functions from different modules?
Calling functions in the same module?
Check again, after calling an outside function that already verifies
the pointer?
Always?

Best Regards,

Geyslan Gregório Bem
hackingbits.com
