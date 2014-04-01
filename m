Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaDANws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:52:48 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51234 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDANwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:52:47 -0400
Date: Tue, 1 Apr 2014 15:52:42 +0200
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Alejandro Comisario <alejandro.comisario@mercadolibre.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        ghammer@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
Subject: Re: [Qemu-devel] Massive read only kvm guests when backing file was
 missing
Message-ID: <20140401135242.GC7972@stefanha-thinkpad.redhat.com>
References: <CAMrG31z=oy-53Lfya4svhNniD_7Q1YETuHeZsotHj8U5xJNYmw@mail.gmail.com>
 <20140327064158.GA17563@redhat.com>
 <87y4zwt7mu.fsf@blackfin.pond.sub.org>
 <20140327081040.GA21756@redhat.com>
 <20140327085347.GB9580@stefanha-thinkpad.redhat.com>
 <CAMrG31wx5WLrFMmGg-uasugS+S=e8T156ZPuEofRJeVB-4fVeQ@mail.gmail.com>
 <53351E2C.3070508@msgid.tls.msk.ru>
 <20140328084749.GA11688@stefanha-thinkpad.redhat.com>
 <CAMrG31ykbYAChLhF5qoUUCFU-tpdxNd5mcWyVOW7DuV-USEHrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMrG31ykbYAChLhF5qoUUCFU-tpdxNd5mcWyVOW7DuV-USEHrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:51:23PM -0300, Alejandro Comisario wrote:
> Again, thanks to everyone.

Did you reach a conclusion or is there still a problem that might be a
bug in KVM?

Stefan
