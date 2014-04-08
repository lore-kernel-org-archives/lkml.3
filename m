Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaDHMmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:42:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:53779 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbaDHMml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:42:41 -0400
Message-ID: <5343EE56.6010809@gmx.at>
Date: Tue, 08 Apr 2014 14:40:54 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org,
        Manfred Schlaegl <manfred.schlaegl@ginzinger.com>
Subject: [PATCH] tty: Fix race condition between __tty_buffer_request_room
 and flush_to_ldisc
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:yQo3BZNiKtwRlPJ0JP2tjdeSjgZfco398ams5SoJFuhz0Y6Uyj5
 tZO1cok+JfeMsuQlp2EbYXH1iqFxUNoPb4HJB1zYcZTmjJOhnVj+YGmAXnLymujlI+gc0Ne
 F4YvbIT/7dKO5UVVKyWxF4zMtAo1vFHkbrp3AjhrzapIgTp0VnEuBFTGAme73O2+9sMLpuI
 znzUWOyRar/nip/ip1+JQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

