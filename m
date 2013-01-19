Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3ASI50 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 03:57:26 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62132 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3ASI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 03:57:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130116165141.GA18593@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
	<20130116113522.GR11529@redhat.com>
	<20130116165141.GA18593@gmail.com>
Date: Sat, 19 Jan 2013 10:57:24 +0200
X-Google-Sender-Auth: 0ByI029X9eNQR7iSM4QkqZ4Wky8
Message-ID: <CAOJsxLHHTY2zzxCJ8647nHyhYXm-jgmHQ4p9b1K40hvEDXNrTQ@mail.gmail.com>
Subject: Re: [PATCH v2] kvm tools: close opened file
From: Pekka Enberg <penberg@kernel.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 6:51 PM, Cong Ding <dinggnu@gmail.com> wrote:
> The file should be closed before return.
>
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Applied, thanks!
