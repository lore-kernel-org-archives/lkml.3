Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3AZIRs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 03:17:48 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:60165 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3AZIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 03:17:45 -0500
Message-ID: <510390FD.6050206@gmail.com>
Date: Sat, 26 Jan 2013 16:17:01 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Consult] Plan: personal contributes plan for 2013
References: <50FFCA59.5070903@asianux.com> <30811.1359070263@turing-police.cc.vt.edu> <20130125021437.GA28908@thunk.org> <5101EE2B.3080004@asianux.com>
In-Reply-To: <5101EE2B.3080004@asianux.com>
Content-Type: multipart/mixed;
 boundary="------------020605000401040500080306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020605000401040500080306
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello all:

Opinion:
  after think of again, for "10 patches per month":
  I think in kernel wide, it is not quite hard to perform.

Finished:
  currently (within Jan 2013)
    in next-20130125 tree, can find about 11 patches of mine.
      patch contents: usb, staging, tty sub-systems, ...
      patch type:     1 for MAINTAINER, 1 for beautify code,
                      others for memory override or resource management.
      marked as:      9 for Signed-of-by, 2 for Reported-by
    (please use "git log", then search "Chen Gang" to get details)
    (also, I do it in part time in Jan 2013)

Ways:
  for memory override:
    A) search strcpy, strncpy, sprintf, and memcpy in kernel wide
    B) we will get more than 10,000 lines (maybe almost 100,000 lines).
    C) then see each of them.
    in my experience (statistic): can find a bug per 10 lines.

  for resource management:
    A) at least, we can search 'kfree' in kernel wide
    B) we will get more than 10,000 lines (maybe almost 100,000 lines).
    C) then see each of them.
    in my experience (statistic): can find a bug per 100 lines.

Hope:
  if most of my patches are qualified both for "Accept" and for "Quality"

    I hope to share this simple way to every one.
    so that, most of us can provide more valuable patches in this simple way.

  else (most of my patches are not qualified)

    please give reasons.
    if really they are, I should notice next time (also need adjust my plan)


  thanks


-- 
Chen Gang

Flying Transformer

--------------020605000401040500080306
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------020605000401040500080306--
