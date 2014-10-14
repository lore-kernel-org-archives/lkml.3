Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaJNL0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:26:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59557 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbaJNL0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:26:04 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] ext4: Add fdatasync scalability optimization
In-Reply-To: <20141014105729.GA19981@infradead.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org> <1413281035-6483-5-git-send-email-dmonakhov@openvz.org> <20141014105729.GA19981@infradead.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Tue, 14 Oct 2014 15:25:54 +0400
Message-ID: <87oateq4e5.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain

Christoph Hellwig <hch@infradead.org> writes:

> Much of the bookkeeping here seems generic and should be in common
> code and not inside a filesystem.
Yes. But this means that I need to store flush_id inside generic inode
which likely will be accepted negatively because VFS people do not like
inode bloating. But if you are OK then I'll prepare the patch.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPQhCAAoJEFzOBSYIXfve40gP+wfx5+x6c6NEMQ2n7LdBumCC
0I5/G9gBV2SRFjf7tvbW7jW3U5qrfjUZizTOGBvcoX9zt35ClMKMUWvTqBHHaN2+
Zix9kdXhFheKKvuKR0II4lwh2kYIAoosfqwYTOX6RWtdFbul66rPynU0+KTSEbay
VZLrZZ38TQuDgIvrmAwbwnINX6/ZIs9KwQQS63OT6og4SWsqj5lo+tVEoAQdAeKV
5pDVYo0sO6R2OqF9pi+BPBI+4jNXNV7RH17Swj3PUJLsjB0jOehrIPw9FS13vXdK
JW+d7A9tv47lwrp+Z7BUPQx/u40DxIIiTpjbMVi+tutgNmT4VnXr9j4odFK1SbSO
3BRB0BpgvL9YPBBiHKGarHkgvZ/MDkNEbufoSQhL6PFKF40tcBT4gnTbmB0f5EJM
3LaHUIfonPpyJ8ziYNKAa+yFi+epAWOZnQUjfQhoek2s4l70TOZk+z+J9zr08VKg
NCmLRPhMEULgdO6RkHnwNC/rhQMId3s6TKXxqXbKGN9vgtS1rLkb/cEgR5opIcg9
9PpxdN0xhctclsAElk7LZUpK4KA7hzFr51IG3BnzACBd0x9h6DcJ+mYRAYYaEwBO
SQy8Y9dy1VCcPrcwX3xWtwt3Su0OjVxSg42W71eg396cll1LZLgV24MAQFC89mBh
YfplMyeM5u4b+A3i2DCt
=j/Z9
-----END PGP SIGNATURE-----
--=-=-=--
