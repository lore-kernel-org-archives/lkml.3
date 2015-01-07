Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbbAGFtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:49:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:15583 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbbAGFtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:49:00 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-94-54acc8ca350e
From: Namjae Jeon <namjae.jeon@samsung.com>
To: "'Brian Foster'" <bfoster@redhat.com>
Cc: "'Dave Chinner'" <david@fromorbit.com>, "'Theodore Ts'o'" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'linux-ext4'" <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        "'Ashish Sangwan'" <a.sangwan@samsung.com>
References: <004901d02670$835ac120$8a104360$@samsung.com>
 <20150106181323.GI5874@bfoster.bfoster>
In-reply-to: <20150106181323.GI5874@bfoster.bfoster>
Subject: RE: [PATCH v7 11/11] xfstests: fsx: Add fallocate insert range
 operation
Date: Wed, 07 Jan 2015 14:48:57 +0900
Message-id: <001901d02a3d$a10cd9d0$e3268d70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQL7d2zMpqHVPsskxEt3+n+R89EJ/wKgNHxemkhz6AA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsWyRsSkUPfUiTUhBmdvsFssnXiJ2eLd5yqL
	LcfuMVrMnHeHzWLP3pMsFpd3zWGzaO35yW6xqO8WowOHx6lFEh5NZ44ye6y+sJXR4/2+q2we
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbH/5WSmgk9cFa8WvGdvYFzC0cXIySEhYCJx+PhF
	VghbTOLCvfVsXYxcHEICSxkl7qzYxtTFyAFW9HFmGER8OqPEy7YGJgjnL6PEitUnmEGK2AS0
	Jf5sEQUZJCKgLnFn3gQWkBpmgU+MEg+vHGAGSQgJJEs8mvwAzOYEGvrmVhM7iC0sECwxoeEO
	E4jNIqAqMXnVTbAaXgFLifVzX7JD2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniAwWJHWdf
	M0IcYSWx8d0sqBoRiX0v3jGCHCQh8JNd4tPEr8wQywQkvk0+xALxpazEpgNQcyQlDq64wTKB
	UWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIjOfT/55N2MF4
	74D1IUYBDkYlHt6CvjUhQqyJZcWVuYcYTYEumsgsJZqcD0waeSXxhsZmRhamJqbGRuaWZkri
	vK+lfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPRav8Ln1McQhaB6xf0pgv9v2qZ2z66e
	xs74R70qSnvJfFfd/DNrJ4U3mK9+t+Y435+YH1EKamuuz1ql5V5YrRvinLDguooYe133A553
	akcj3s9SE3PdcWhh8/37iUv31MjvVfC9tJ7X1/rD/SiPvGxPkZfuO0xac7qDnrcHvmhgVLBm
	11p8S4mlOCPRUIu5qDgRAPcdUwfiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd2TJ9aEGKx7YmOxdOIlZot3n6ss
	thy7x2gxc94dNos9e0+yWFzeNYfNorXnJ7vFor5bjA4cHqcWSXg0nTnK7LH6wlZGj/f7rrJ5
	9G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
	i0+ArltmDtA9SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM/S8nMxV8
	4qp4teA9ewPjEo4uRg4OCQETiY8zw7oYOYFMMYkL99azdTFycQgJTGeUeNnWwATh/GWUWLH6
	BDNIA5uAtsSfLaIgDSIC6hJ35k1gAalhFvjEKPHwygFmkISQQLLEo8kPwGxOoAVvbjWxg9jC
	AsESExruMIHYLAKqEpNX3QSr4RWwlFg/9yU7hC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5kh
	LlWQ2HH2NSPEEVYSG9/NgqoRkdj34h3jBEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJEZwsnkntYFzZYHGIUYCDUYmHt6BvTYgQa2JZcWXuIUYJDmYlEV6r
	TqAQb0piZVVqUX58UWlOavEhRlOgTycyS4km5wMTWV5JvKGxiZmRpZG5oYWRsbmSOK+SfVuI
	kEB6YklqdmpqQWoRTB8TB6dUA2PbUna2t7msV+S3W19/crw1+Skrz68bxk3X3m664fuR94KD
	X7a73LRFM+s38rV/uvZkk4zrwo2su/ueP5nqGuv/6/uzw6o77nC7XVcMfPtuS3r6pesHDF0P
	OU22E7eS/frOKzd9jqrnjIJJh07KPTA3umF42ODa5BM723+qJMVOqdf5u1Ux8FOXEktxRqKh
	FnNRcSIA6FrkLywDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  		}
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		if (!insert_range_calls) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +		break;
> >  	}
> >
> >  	switch (op) {
> > @@ -1244,6 +1313,21 @@ test(void)
> >  		}
> >  		do_collapse_range(offset, size);
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		TRIM_OFF_LEN(offset, size, (maxfilelen - 1) - file_size);
> 
> I see a ton of "skipping insert beyond EOF" messages when I run fsx with
> this patch that boil down to that we trim against the max allowable file
> size increase rather than the current file size. I suspect the intent
> here is to not limit the insert length based on the file size. That
> makes sense, but that causes us to fail to mod the insert offset against
> the file size and thus generate a ton more noise.
> 
> Could we either open code the trim to handle the offset/len correctly or
> break up the macro in a way that facilitates doing so? For example, a
> quick solution might be to create TRIM_OFF() and TRIM_LEN() based on the
> associated code in TRIM_OFF_LEN(), redefine TRIM_OFF_LEN() to use the
> new macros, and then the insert range code could do something like:
> 
> 	TRIM_OFF(offset, file_size - 1);
> 	TRIM_LEN(offset, size, maxfilelen - file_size);
> 	...
> 
Okay, I will change it as your suggestion.

> Brian
> 

