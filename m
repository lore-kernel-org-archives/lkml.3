Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab3AQEE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 23:04:56 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:60485 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQEEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 23:04:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu> <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Wed, 16 Jan 2013 23:04:33 -0500
X-Google-Sender-Auth: vzcGkjyDU2LJDXHYYVt-EOh5vvw
Message-ID: <CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:51 PM, Steve French <smfrench@gmail.com> wrote:
> How did you discover this - did you have an ipv6 test case or by
> inspection or ...?

By mostly-automated inspection (i.e., with the help of a static
program analysis tool).

Nickolai.
