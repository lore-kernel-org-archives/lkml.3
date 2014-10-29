Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbaJ2XQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:16:10 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34186 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaJ2XQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:16:08 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 29 Oct 2014 16:15:46 -0700
X-Google-Sender-Auth: tAm9TBPwP6GSAz4DiHTEanmEqUM
Message-ID: <CAB=NE6UcT9suZDfnTY09rOoqOSoYEqV2fryCSo7BjJyqXKXewQ@mail.gmail.com>
Subject: Tool to match kernel C file to CONFIG symbol
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone familiar with a tool to match a specific C file to a respective
CONFIG symbol on the kernel? I'd prefer if its written in C or Python.
This should be easy to write if we don't have it yet.

 Luis
