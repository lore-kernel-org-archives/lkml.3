Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaGHQf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:35:29 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61895 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaGHQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:35:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140708160417.47fb4d7c@canb.auug.org.au>
References: <1404795849-25609-1-git-send-email-xerofoify@gmail.com>
	<20140708160417.47fb4d7c@canb.auug.org.au>
Date: Tue, 8 Jul 2014 12:35:27 -0400
Message-ID: <CAPDOMVitjYMkoLAbwf6oBJg+fpFdKLi+S4hTm6opD27DMC1NDw@mail.gmail.com>
Subject: Fwd: powerpc allyesconfig fix
From: Nick Krause <xerofoify@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        mahesh <mahesh@linux.vnet.ibm.com>, Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>, paulus@samba.org,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: multipart/mixed; boundary=089e0118263ce4b6e604fdb12de2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0118263ce4b6e604fdb12de2
Content-Type: text/plain; charset=UTF-8

From: Stephen Rothwell wrote on Tue, Jul 8, 2014 at 2:04 AM
Subject: Re: powerpc allyesconfig fix

Hi Nicholas,

On Tue,  8 Jul 2014 01:04:09 -0400 Nicholas Krause <xerofoify@gmail.com> wrote:
>
> powerpc:allmodconfig has been failing for some time with the following
> error.

This patch has already bee submitted directly by Guenter, however for
future reference:  when you submit someone else's patch, you should
include a From line as the first line of the email body containing their
email address and you should include a Signed-off-by line from yourself.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


Hey Stephen,
Thanks for the heads up on submitting other people's patches. It would
be great if you can push this up into Linus's tree
for the next developer release.
--
Cheers Nick

--089e0118263ce4b6e604fdb12de2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: 63f63287fb3b277f_0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0NClZlcnNpb246IEdudVBHIHYyDQoNCmlRSWNC
QUVCQ0FBR0JRSlR1NG5tQUFvSkVNRFRhOElyN1p3VjRtSVFBSTFmaXZCTmJiWEQ1L24vNFErelRy
c1cNClpYSi9wQmFsWFB1dC9KcG5hWEVhY3Zmd0tJMFFGVmh0eEVENWhQWWovT2p4TWZ3c0hkazdG
RmZjZ3VqWW5Qa0INCnVQbDJ5UU5pRWVKV0tIRHRqRjZhTk5PNjladXFUcExlWWpXajhuckd0Wldr
ZEV0VmRzaVFDUFpLSThZaTVKeVYNCkdNVlNXOHJ3V0FxZHdTckFyVUhSOHdtbS9kZ1c5aW1nMS93
azV1aElnQUJ2TWpzMFVuRGhJcDRNNGlIUHVOWUsNClZJanpJSFlPMEJGMnJ0ZUZpaWxmc0l4R0lF
MFh5N3E0bjdYc2VLdVpNdDhtZTFJRUl0UEhzeVZBbTlGOUYvVzQNClFqT2t4U0Uzam5EVkRIL1RT
cHJjMFg4cUlMZ2lQdHN1M0daRm1SYlZWbldIV1duV0JxZ2pUbkRwNytvenVaaTkNCkJtanFGa05p
NkdXR1NBaXZUYUtVcG96S053UWcyeFZURC95a3JYWm1KSFk2VDQ3RHVxUVRRb0FTSjd2dlVVUTIN
Ck1jVVUwTFI4aVgvT3NxeXJIaFpPZm40ZVRHalVuOWhpc2k1bmNPa1lQUktaZFU5Y0xmRUtTeDV0
ZjI2SkNUZnUNClF5UDNuOE5qeW51M1pVU2xLRk5ZN0EvL2t0ak9rNmNsek9rYnI5ZE9XcmlXQkdB
b1kzSGdPeUhjb2hUalh6YzcNCm9kVUMwanNsenRpWTV6Ym80OU5IQTFyQkNaRHh4M0lQMDAvQUxJ
VkhVR1NyV0FOV0ErcFlQOVBPMENUajdUVU4NCnFWYzRqOVlkYU8yNEN4VThxbWtka1NxYUZkZ0FE
MXJTalhZL1BPOGlBZGlBVzFiSkQzcVpRMENiZDBQakg5ckUNClk1OThOLzE0WGdPQUZMZDhUQy9D
DQo9ei9wUw0KLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tDQo=
--089e0118263ce4b6e604fdb12de2--
