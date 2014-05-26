Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaEZN1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:27:08 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54991 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaEZN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:27:07 -0400
MIME-Version: 1.0
Date: Mon, 26 May 2014 16:27:04 +0300
Message-ID: <CACVxJT82k0YO7eo8ECu3Rq__vu8L6TE2rhwVGoGLk_7nj+SYFg@mail.gmail.com>
Subject: kernel-doc (was Re: + lib-digsigc-kernel-doc-warning-fixes.patch
 added to -mm tree)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: duanj.fnst@cn.fujitsu.com, fabf@skynet.be
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:28 PM,  <akpm@linux-foundation.org> wrote:
>   * digsig_verify() - digital signature verification with public key
>   * @keyring:   keyring to search key in
>   * @sig:       digital signature
> - * @sigen:     length of the signature
> + * @siglen:    length of the signature
>   * @data:      data
>   * @datalen:   length of the data

Does anyone use kernel-doc generated documentation?
I'm serious.

  Alexey
