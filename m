Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3JKQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:36:50 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:56263 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab3JKQgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:36:49 -0400
MIME-Version: 1.0
Date: Fri, 11 Oct 2013 17:36:48 +0100
Message-ID: <CABfLueHiw+h99pHficnAtAwvsmqFBp7EakHuC=7WJeBG2QR7eQ@mail.gmail.com>
Subject: SIT Tunnel: Generate an ICMPV6 message and send them back to the
 original IPV6 node
From: Oussama Ghorbel <ou.ghorbel@gmail.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In RFC 4213, section 3.4, page 11, it says:
If sufficient data bytes from the offending packet are available, the
encapsulator MAY extract the encapsulated IPv6 packet and use it to
generate an ICMPv6 message directed back to the originating IPv6  node.

Currently, linux does not do that.
More info on the RFC: http://tools.ietf.org/html/rfc4213
Issue described also in  https://bugzilla.kernel.org/show_bug.cgi?id=49761

I'm considering to implement this feature.
Will be interesting to do it?

Regards,
Oussama
