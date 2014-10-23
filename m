Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbaJWUAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:00:20 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60109 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaJWUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:00:18 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 23 Oct 2014 12:59:56 -0700
X-Google-Sender-Auth: QSwD62GS-GQYgdGuDOYQgAT3oRc
Message-ID: <CAB=NE6Wst7qmtUrF6aM_z+dzOO+9Dmjyxrbtpw0croEjYXsvTQ@mail.gmail.com>
Subject: git tag for counting uses of Coccinelle
To: "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to help be able to easily count uses of Coccinelle for kernel
development I'd like to propose the use of the tag:

Generated-by: Coccinelle SmPL

This would save space on commits where it seems more than the above
number of words are used to describe this exact thing.

  Luis
